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
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_default_vpc.default.id
  availability_zone = "${var.secondary_availability_zone}"
  cidr_block = "172.31.65.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-role"
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

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterBuildPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = var.codebuild_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServiceBuildPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = var.codebuild_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_role.name
}

module "security_groups" {
  source = "./modules/security-groups"

  cluster_name = var.cluster_name
}

data "aws_security_group" "ssh_sg" {
  name = var.ssh_security_group_name
}

resource "aws_eks_cluster" "cluster" {
  name     = "${var.cluster_name}"
  role_arn = aws_iam_role.cluster_role.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_group_ids = [
      data.aws_security_group.ssh_sg.id,
      module.security_groups.base_sg_id,
      module.security_groups.node_sg_id,
      module.security_groups.ark_sg_id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.cluster_logs
  ]
}

resource "aws_cloudwatch_log_group" "cluster_logs" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  # ... potentially other configuration ...
}

module config_map {
  source = "./modules/config-map"
  
  cluster = aws_eks_cluster.cluster
  codebuild_role = var.codebuild_role
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer

  depends_on = [
    module.config_map
  ]
}

### External cli kubergrunt
data "external" "thumb" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", aws_eks_cluster.cluster.identity.0.oidc.0.issuer]
}
### OIDC config
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumb.result.thumbprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

# TODO: generalize this
resource "aws_iam_role" "oidc_role" {
    name = "jks-gs-dev-use2-oidc-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "Federated": "${aws_iam_openid_connect_provider.oidc_provider.arn}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
              "StringLike": {
                "${aws_iam_openid_connect_provider.oidc_provider.url}:sub": "system:serviceaccount:default:jks-gameservers-dev-ark-serviceaccount"
              }
            }
          }
        ]
    })

    tags = {
      "ServiceAccountName"      = "jks-gameservers-dev-ark-serviceaccount"
      "ServiceAccountNameSpace" = "kube-system"
    }

    depends_on = [aws_iam_openid_connect_provider.oidc_provider]
}

resource "aws_iam_policy" "secrets_access_policy" {
    name = "jks-gs-dev-use2-oidc-secrets-policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:GetRandomPassword",
                    "secretsmanager:GetResourcePolicy",
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret",
                    "secretsmanager:ListSecretVersionIds",
                    "secretsmanager:ListSecrets"
                ],
                "Resource": "*"
            }
        ]
    })
}


resource "aws_iam_role_policy_attachment" "serviceaccount_cni" {
  role       = aws_iam_role.oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  depends_on = [aws_iam_role.oidc_role]
}

resource "aws_iam_role_policy_attachment" "serviceaccount_secrets" {
  role       = aws_iam_role.oidc_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
  depends_on = [aws_iam_role.oidc_role]
}