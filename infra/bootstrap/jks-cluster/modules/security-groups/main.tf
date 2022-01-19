module "base_sg" {
    source = "./base"
}

module "node_sg" {
    source = "./node"

    cluster_name = var.cluster_name
}

module "ark_sg" {
    source = "./Ark"
}