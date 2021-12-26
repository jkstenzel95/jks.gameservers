locals {
    server_mount_location = "/mnt/gameservers"
    initialized_flag_file = "${local.server_mount_location}/init_flag"
    common_script = templatefile("${path.module}/../../scripts/launch.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}", server_mount_location = "${local.server_mount_location}" })
    server_setup_script = templatefile("${path.module}/../../scripts/${var.game_name}-setup.tpl", { volume_id = "${var.data_volume_id}", region = "${var.server_region}", server_mount_location = "${local.server_mount_location}", init_flag = "${local.initialized_flag_file}", resource_bucket_name = "${var.resources_bucket_name}" })
    full_launch_script = "${local.common_script}\n\n${local.server_setup_script}\n\ntouch ${local.initialized_flag_file}"
}

# the role that will be used by the instance
module "instance_iam_profile" {
    source = "./../instance-profile"

    game_name = "${var.game_name}"
    map_name = "${var.map_name}"
    data_volume_id = "${var.data_volume_id}"
    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
}

resource "aws_iam_role_policy_attachment" "ec2-instance-policy-attachment" {
    role = module.instance_iam_profile.role_name
    policy_arn = var.game_policy_arn
}

# the launch template for the spot fleet
resource "aws_launch_template" "launch_template" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-lt"
    iam_instance_profile {
      name = module.instance_iam_profile.name
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

    user_data = base64encode("${local.full_launch_script}")

    instance_market_options {
      market_type = "spot"
      spot_options {
        spot_instance_type = "persistent"
      }
    }

    image_id = "${var.server_image_id}"
}

resource "aws_iam_role" "node_role" {
  name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-node_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "game_node" {
    cluster_name    = "${var.cluster_name}"
    node_group_name = "jks-gameservers-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-node_group"
    node_role_arn   = aws_iam_role.node_role.arn
    subnet_ids      = [ var.subnet_id ]
    instance_types = [ "${var.instance_type}" ]
    capacity_type = "SPOT"
    labels = {
        game = "${var.game_name}"
        map = "${var.map_name}"
    }
    
    launch_template {
        id = aws_launch_template.launch_template.id
        version = "$Latest"
    }

    scaling_config {
        desired_size = 1
        max_size     = 1
        min_size     = 1
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}