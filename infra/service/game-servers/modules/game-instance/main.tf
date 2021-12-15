# the role that will be used in attaching the volume to a machine on startup
resource "aws_iam_role" "spot_launch_iam_role" {
    name = "jks-gameservers-${var.region_shortname}-${var.game_name}-${var.map_name}-iam-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": [
                        "ec2.amazonaws.com"
                    ]
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "policy" {
    name = "jks-gs-${var.region_shortname}-${var.game_name}-${var.map_name}-attach-policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:AttachVolume",
                    "ec2:DetachVolume"
                ],
                "Resource": [
                    "arn:aws:ec2:*:*:instance/*",
                    "arn:aws:ec2:*:*:volume/${var.data_volume_id}"
                ]
            },
            {
                "Effect": "Allow",
                "Action": "ec2:DescribeVolumes",
                "Resource": "arn:aws:ec2:*:*:volume/${var.data_volume_id}"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
    role = "jks-gameservers-${var.region_shortname}-${var.game_name}-${var.map_name}-iam-role"
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "spot_launch_iam_profile" {
    name = "jks-gameservers-${var.region_shortname}-${var.game_name}-${var.map_name}-iam-profile"
    role = aws_iam_role.spot_launch_iam_role.name
}

# the launch template that will attach the volume to a spot instance on launch
resource "aws_launch_template" "spot_launch_template" {
    name = "jks-gameservers-${var.region_shortname}-${var.game_name}-${var.map_name}-launch-template"
    iam_instance_profile {
      name = aws_iam_instance_profile.spot_launch_iam_profile.name
    }

    user_data = base64encode(templatefile("${path.module}/launch.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}" }))

    instance_market_options {
      market_type = "spot"
      spot_options {
        max_price = 0.03
        spot_instance_type = "persistent"
      }
    }

    image_id = "ami-056b1936002ca8ede"
    instance_type = "${var.instance_type}"

    network_interfaces {
      associate_public_ip_address = true
    }
}

# somehow this needs to be used to create the instance
resource "aws_autoscaling_group" "spot_instance_autoscale_group" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-asg"
    availability_zones = ["${var.server_region}a"]
    desired_capacity   = 1
    max_size           = 1
    min_size           = 1

    launch_template {
        id      = "${aws_launch_template.spot_launch_template.id}"
        version = "$Latest"
    }

    tag {
        key = "Name"
        value = "${var.game_name}_${var.map_name}"
        propagate_at_launch = true
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