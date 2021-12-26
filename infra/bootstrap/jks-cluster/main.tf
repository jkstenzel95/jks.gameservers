locals {
    cluster_name = "jks-${var.region_shortname}"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_default_vpc.default.id
  availability_zone = "${var.primary_availability_zone}"
  cidr_block = "172.31.64.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_default_vpc.default.id
  availability_zone = "${var.secondary_availability_zone}"
  cidr_block = "172.31.65.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_iam_role" "cluster_role" {
  name = "${local.cluster_name}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "cluster" {
  name     = "${local.cluster_name}"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}