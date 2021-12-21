locals {
    dedicated_count = var.use_spot_instance ? 0 : 1
    spot_count = var.use_spot_instance ? 1 : 0
}

# the role that will be used in attaching the volume to a machine on startup
module "instance_launch_iam_profile" {
    source = "./../volume-attach-profile"

    game_name = "${var.game_name}"
    map_name = "${var.map_name}"
    data_volume_id = "${var.data_volume_id}"
    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
}

# the launch template that will attach the volume to an instance on launch
resource "aws_launch_template" "launch_template" {
    name = "jks-gameservers-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-lt"
    iam_instance_profile {
      name = module.instance_launch_iam_profile.name
    }

    security_group_names = [
        "jks-gs-${var.env}-server_base-sg",
        "${var.additional_security_group_name}",
        "jks-ssh-group"
    ]

    update_default_version = true

    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = 10
        }
    }

    user_data = base64encode(templatefile("${path.module}/../../scripts/launch.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}" }))

    instance_market_options {
      market_type = "spot"
      spot_options {
        spot_instance_type = "one-time"
      }
    }

    image_id = "ami-0a672c79e61374a45"

    network_interfaces {
      associate_public_ip_address = true
    }
}

resource "aws_iam_role" "fleet_role" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-fleet_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "spotfleet.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-fleet-policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "ec2:DescribeSubnets",
                "ec2:RequestSpotInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:CreateTags",
                "ec2:RunInstances"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "ec2.amazonaws.com",
                        "ec2.amazonaws.com.cn"
                    ]
                }
            },
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:RegisterTargets"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-fleet-policy-attachment" {
    role = aws_iam_role.fleet_role.name
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_spot_fleet_request" "spot_fleet" {
    iam_fleet_role = aws_iam_role.fleet_role.arn
    spot_price = "0.03"
    allocation_strategy = "lowestPrice"
    target_capacity = local.spot_count
    fleet_type = "maintain"

    launch_template_config {
        launch_template_specification {
            id = aws_launch_template.launch_template.id
            version = "$Latest"
        }

        overrides {
            instance_type = "a1.xlarge"
            availability_zone = "${var.server_region}a"
        }

        overrides {
            instance_type = "a1.xlarge"
            availability_zone = "${var.server_region}b"
        }
        
        overrides {
            instance_type = "a1.xlarge"
            availability_zone = "${var.server_region}c"
        }

        overrides {
            instance_type = "c6g.xlarge"
            availability_zone = "${var.server_region}a"
        }

        overrides {
            instance_type = "c6g.xlarge"
            availability_zone = "${var.server_region}b"
        }

        overrides {
            instance_type = "c6g.xlarge"
            availability_zone = "${var.server_region}c"
        }

        overrides {
            instance_type = "c6gn.xlarge"
            availability_zone = "${var.server_region}a"
        }

        overrides {
            instance_type = "c6gn.xlarge"
            availability_zone = "${var.server_region}b"
        }

        overrides {
            instance_type = "c6gn.xlarge"
            availability_zone = "${var.server_region}c"
        }

        overrides {
            instance_type = "c6i.xlarge"
            availability_zone = "${var.server_region}a"
        }

        overrides {
            instance_type = "c6i.xlarge"
            availability_zone = "${var.server_region}b"
        }

        overrides {
            instance_type = "c6i.xlarge"
            availability_zone = "${var.server_region}c"
        }
    }

    tags = {
        Name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-spot_fleet"
        game = "${var.game_name}"
        map = "${var.map_name}"
        env = "${var.env}"
    }
}

# this ensures there is an instance running
resource "aws_autoscaling_group" "dedicated_autoscale_group" {
    count = local.dedicated_count
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-asg"
    availability_zones = ["${var.server_region}a"]
    desired_capacity   = 1
    max_size           = 1
    min_size           = 1
    wait_for_capacity_timeout = 0

    launch_template {
        id      = "${aws_launch_template.launch_template.id}"
        version = "$Latest"
    }

    tag {
        key = "game"
        value = "${var.game_name}"
        propagate_at_launch = true
    }

    tag {
        key = "map"
        value = "${var.map_name}"
        propagate_at_launch = true
    }

    tag {
        key = "env"
        value = "${var.env}"
        propagate_at_launch = true
    }
}