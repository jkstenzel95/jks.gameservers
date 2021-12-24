locals {
    server_mount_location = "/mnt/gameservers"
    common_script = templatefile("${path.module}/../../scripts/launch.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}", server_mount_location = "${local.server_mount_location}" })
    server_setup_script = templatefile("${path.module}/../../scripts/${var.game_name}-setup.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}", server_mount_location = "${local.server_mount_location}" })
    full_launch_script = "${local.common_script}\n\n${local.server_setup_script}"
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

    vpc_security_group_ids = [
        "${var.base_security_group_id}",
        "${var.additional_security_group_id}",
        "${var.ssh_security_group}"
    ]

    key_name = "jks-gameservers"

    update_default_version = true

    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = 15
        }
    }

    # user_data = base64encode("${local.full_launch_script}")

    instance_market_options {
      market_type = "spot"
      spot_options {
        spot_instance_type = "one-time"
      }
    }

    image_id = "${var.server_image_id}"
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
    # TODO: CHANGE THIS BACK TO 0.3 ONCE THIS BUG RESOLVES: https://github.com/hashicorp/terraform/issues/30244
    spot_price = "0.355"
    allocation_strategy = "lowestPrice"
    target_capacity = 1
    fleet_type = "maintain"

    launch_template_config {
        launch_template_specification {
            id = aws_launch_template.launch_template.id
            version = "$Latest"
        }

        overrides {
            instance_type = "${var.instance_type}"
            availability_zone = "${var.availability_zone}"
        }
    }

    tags = {
        Name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-spot_fleet"
        game = "${var.game_name}"
        map = "${var.map_name}"
        env = "${var.env}"
    }
}