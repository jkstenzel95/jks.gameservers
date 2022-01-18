data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.cluster.name}"
}

provider "kubernetes" {
  host                   = "${var.cluster.endpoint}"
  cluster_ca_certificate = "${base64decode(var.cluster.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<YAML
- rolearn: ${var.codebuild_role.arn}
  username: kubectl-access-user
  groups:
    - system:masters
YAML
  }
}