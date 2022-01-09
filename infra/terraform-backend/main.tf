provider aws {
    profile = "default"
    region  = "us-east-2"
}

module "dev_state_store" {
    source = "./env"
    env_region_identifier = "dev-use2"
}

module "prod_state_store" {
    source = "./env"
    env_region_identifier = "prod-use2"
}

module "shared_state_store" {
    source = "./env"
    env_region_identifier = "shared"
}