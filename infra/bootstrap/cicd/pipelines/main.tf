module "infra_pipeline" {
    source = "./infra"

    role_arn = var.role_arn
}
module "game_servers_pipeline" {
    source = "./game-servers"

    role_arn = var.role_arn
}