locals {
  cluster_cidr_blocks = [ "172.31.64.0/24", "172.31.65.0/24" ] 
}

resource "aws_security_group" "node_security_group" {
  name        = "jks-gs-node-sg"
  description = "Security group for all nodes in the cluster"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jks-gs-node-sg"
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