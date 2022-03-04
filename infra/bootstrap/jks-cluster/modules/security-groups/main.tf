module "games_sg" {
    source = "./games"
}

module "node_sg" {
    source = "./node"

    cluster_name = var.cluster_name
}