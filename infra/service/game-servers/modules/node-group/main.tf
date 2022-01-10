locals {
    server_mount_location = "/mnt/gameservers"
    initialized_flag_file = "${local.server_mount_location}/init_flag"
    common_script = templatefile("${path.module}/../../scripts/launch.tpl", 
      { 
        volume_id = "${var.data_volume_id}",
        region = "${var.server_region}",
        SERVER_MOUNT_LOCATION = "${local.server_mount_location}",
        GAME_NAME = "${var.game_name}",
        MAP_NAME = "${var.map_name}",
        ENV = "${var.env}",
        REGION_SHORTNAME = "${var.region_shortname}",
        BACKUP_STORAGE_NAME = "${var.backup_bucket_name}",
        RESOURCE_BUCKET_NAME = "${var.resources_bucket_name}"
      })
    full_launch_script = "${local.common_script}\n\ntouch ${local.initialized_flag_file}"
    cluster_cidr_blocks = [ "172.31.64.0/24", "172.31.65.0/24" ] 
}

# the role that will be used by the instance
module "instance_iam_role" {
    source = "./../instance-role"

    game_name = "${var.game_name}"
    map_name = "${var.map_name}"
    data_volume_id = "${var.data_volume_id}"
    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
}

resource "aws_iam_role_policy_attachment" "ec2-instance-policy-attachment" {
    role = module.instance_iam_role.name
    policy_arn = var.game_policy_arn
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

resource "aws_security_group" "node_security_group" {
  name        = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-node_sg"
  description = "Security group for all nodes in the cluster"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
  }
}

resource "aws_security_group_rule" "node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node_security_group.id}"
  source_security_group_id = "${aws_security_group.node_security_group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster-https" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node_security_group.id}"
  cidr_blocks              = local.cluster_cidr_blocks
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster-others" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node_security_group.id}"
  cidr_blocks              = local.cluster_cidr_blocks
  to_port                  = 65535
  type                     = "ingress"
}

# the launch template for the spot fleet
resource "aws_launch_template" "launch_template" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-lt"

    vpc_security_group_ids = [
        "${var.base_security_group_id}",
        "${var.additional_security_group_id}",
        "${var.ssh_security_group}",
        "${aws_security_group.node_security_group.id}"
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
    image_id = "${var.server_image_id}"
}

resource "aws_eks_node_group" "game_node" {
    cluster_name    = "${var.cluster_name}"
    node_group_name = "jks-gameservers-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-node_group"
    node_role_arn   = module.instance_iam_role.arn
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

    taint {
      key = "game"
      value = "${var.game_name}"
      effect = "NO_EXECUTE"
    }

    taint {
      key = "map"
      value = "${var.map_name}"
      effect = "NO_EXECUTE"
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