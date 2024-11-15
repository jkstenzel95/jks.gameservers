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
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_default_vpc.default.id
  availability_zone = "${var.secondary_availability_zone}"
  cidr_block = "172.31.65.0/24"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
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
      module.security_groups.games_sg_id,
      module.security_groups.node_sg_id,
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

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${var.cluster_name}"
  provider_url                  = replace(aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = "${var.cluster_name}"
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.36.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
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
                "${aws_iam_openid_connect_provider.oidc_provider.url}:sub": "system:serviceaccount:default:jks-gameservers-dev-*-serviceaccount",
                "${aws_iam_openid_connect_provider.oidc_provider.url}:aud": "sts.amazonaws.com"
              }
            }
          }
        ]
    })

    tags = {
      "ServiceAccountName"      = "jks-gameservers-dev-ark-serviceaccount"
      "ServiceAccountNameSpace" = "kube-system"
    }
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

resource "aws_iam_policy" "data_access_policy" {
    name = "jks-gs-dev-use2-oidc-data-policy"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
                "Effect": "Allow",
                "Action": [
                    "ec2:AllocateAddress",
                    "ec2:AssociateAddress",
                    "ec2:DescribeAddresses"
                ],
                "Resource": "*"
          },
          {
                "Effect": "Allow",
                "Sid": "DescribeQueryScanBooksTable",
                "Action": "dynamodb:*",
                "Resource": "*"
          },
          {
                "Effect": "Allow",
                "Action": [
                    "s3:ListBucket"
                ],
                "Resource": "*"
          },
          {
            "Effect": "Allow",
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:DeleteObject",
                    "s3:PutObjectAcl"
                ],
            "Resource": "*"
          },
          {
              "Effect": "Allow",
                  "Action": [
                      "route53:ListHostedZonesByName",
                      "route53:ChangeResourceRecordSets"
                  ],
              "Resource": "*"
          }
      ]
    })
}

resource "aws_iam_policy" "volumes_policy" {
  name = "jks-gs-dev-use2-oidc-volumes-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
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

resource "aws_iam_role_policy_attachment" "serviceaccount_data" {
  role       = aws_iam_role.oidc_role.name
  policy_arn = aws_iam_policy.data_access_policy.arn
  depends_on = [aws_iam_role.oidc_role]
}

resource "aws_iam_role_policy_attachment" "serviceaccount_volumes" {
  role       = aws_iam_role.oidc_role.name
  policy_arn = aws_iam_policy.volumes_policy.arn
  depends_on = [aws_iam_role.oidc_role]
}