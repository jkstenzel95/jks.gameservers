output "name" {
    description = "the name of the newly created cluster"
    value = aws_eks_cluster.cluster.name
}

output "endpoint" {
    description = "the endpoint of the newly created cluster"
    value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "primary_subnet_id" {
    description = "the primary subnet id"
    value = module.az1.id
}