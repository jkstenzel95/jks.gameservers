locals {
    dedicated_count = var.use_spot_instance ? 0 : 1
    spot_count = var.use_spot_instance ? 1 : 0
    launch_template = var.use_spot_instance ? aws_launch_template.spot_launch_template[0] : aws_launch_template.dedicated_launch_template[0]
}

# the role that will be used in attaching the volume to a machine on startup
module "spot_launch_iam_profile" {
    source = "./../volume-attach-profile"

    game_name = "${var.game_name}"
    map_name = "${var.map_name}"
    data_volume_id = "${var.data_volume_id}"
}

# the launch template that will attach the volume to a spot instance on launch
resource "aws_launch_template" "spot_launch_template" {
    count = local.spot_count
    name = "jks-gameservers-${var.region_shortname}-${var.game_name}-${var.map_name}-spot-launch-template"
    iam_instance_profile {
      name = module.spot_launch_iam_profile.name
    }

    update_default_version = true

    block_device_mappings {
        device_name = "/dev/sda1"

        ebs {
            volume_size = 20
        }
    }

    user_data = base64encode(templatefile("${path.module}/../../scripts/launch.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}" }))

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

# the launch template that will attach the volume to a spot instance on launch
resource "aws_launch_template" "dedicated_launch_template" {
    count = local.dedicated_count
    name = "jks-gameservers-${var.region_shortname}-${var.game_name}-${var.map_name}-dedicated-launch-template"
    iam_instance_profile {
      name = module.spot_launch_iam_profile.name
    }

    update_default_version = true

    block_device_mappings {
        device_name = "/dev/sda1"

        ebs {
            volume_size = 20
        }
    }

    user_data = base64encode(templatefile("${path.module}/../../scripts/launch.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}" }))

    image_id = "ami-056b1936002ca8ede"
    instance_type = "${var.instance_type}"

    network_interfaces {
      associate_public_ip_address = true
    }
}

# this ensures there is an instance running
resource "aws_autoscaling_group" "instance_autoscale_group" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-asg"
    availability_zones = ["${var.server_region}a"]
    desired_capacity   = 1
    max_size           = 1
    min_size           = 1
    wait_for_capacity_timeout = 0

    launch_template {
        id      = "${local.launch_template.id}"
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