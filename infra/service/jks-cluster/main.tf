locals {
    cluster_name = "jks-${var.env}-${var.region_shortname}"
}

module "az1" {
    source = "./../cluster-subnet"

    cluster_name = "${local.cluster_name}"
    availability_zone = "${var.primary_availability_zone}"
}

module "az2" {
    source = "./../cluster-subnet"

    cluster_name = "${local.cluster_name}"
    availability_zone = "${var.secondary_availability_zone}"
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
    subnet_ids = [module.az1.id, module.az2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}