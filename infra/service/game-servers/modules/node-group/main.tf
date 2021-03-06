locals {
    server_mount_location = "/mnt/${var.game_name}-server"
    initialized_flag_file = "${local.server_mount_location}/init_flag"
    common_script = templatefile("${path.module}/../../scripts/launch.tpl", 
      { 
        volume_id = "${var.data_volume_id}",
        region = "${var.server_region}",
        packages_bucket_name = "${var.packages_bucket_name}",
        cluster_name = "${var.cluster_name}"
        SERVER_MOUNT_LOCATION = "${local.server_mount_location}",
        GAME_NAME = "${var.game_name}",
        MAP_NAME = "${var.map_name}",
        ENVIRONMENT = "${var.env}",
        REGION_SHORTNAME = "${var.region_shortname}",
        BACKUP_STORAGE_NAME = "${var.backup_bucket_name}",
        RESOURCE_BUCKET_NAME = "${var.resources_bucket_name}",
        SETUP_AT_LAUNCH = var.setup_at_launch
        DOMAIN = "${var.domain}"
        PUBLIC_IP_NAME = "${var.public_ip_name}"
      })
    full_launch_script = "${local.common_script}\n\ntouch ${local.initialized_flag_file}"
}

# the role that will be used by the instance
module "instance_iam_role" {
    source = "./../instance-role"

    instance_identifier = "${var.instance_identifier}"
    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
}

resource "aws_iam_role_policy_attachment" "ec2-instance-policy-attachment" {
    count = length(var.game_policy_arns)
    role = module.instance_iam_role.name
    policy_arn = var.game_policy_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = module.instance_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = module.instance_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.instance_iam_role.name
}

# the launch template for the spot fleet
resource "aws_launch_template" "launch_template" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.instance_identifier}-lt"

    vpc_security_group_ids = var.security_group_ids

    key_name = "jks-gameservers"

    update_default_version = true

    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = 15
        }
    }

    user_data = base64encode("${local.full_launch_script}")
    image_id = "${var.server_image_id}"
}

resource "aws_eks_node_group" "game_node" {
    cluster_name    = "${var.cluster_name}"
    node_group_name = "jks-gameservers-${var.env}-${var.region_shortname}-${var.instance_identifier}-node_group"
    node_role_arn   = module.instance_iam_role.arn
    subnet_ids      = [ var.subnet_id ]
    instance_types = [ "${var.instance_type}" ]
    capacity_type = "SPOT"
    labels = {
        "${var.game_name}_${var.map_name}_hosted" = "true" // TODO: What if multiple? What if none? ie only pod setup needed
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

    tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}

resource "aws_eip" "eip" {
    tags = {
        Name = lower("jks-gs-${var.env}-${var.region_shortname}-${var.instance_identifier}")
    }
}