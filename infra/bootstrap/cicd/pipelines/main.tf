module "infra_pipeline" {
    source = "./infra"

    role_arn = var.role_arn
}