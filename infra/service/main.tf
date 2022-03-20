locals {
    BUCKET_NAME = "jks-gs-${var.env}-${var.region_shortname}-state"
    DYNAMODB_NAME = "jks-gs-${var.env}-${var.region_shortname}-state-locks"
}

terraform {
    backend "s3" { 
        bucket          = locals.BUCKET_NAME
        key             = "global/s3/terraform.tfstate"
        region          = "us-east-2"

        dynamodb_table  = locals.DYNAMODB_NAME
        encrypt         = true
    }
    
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.70"
        }
    }

    required_version = ">= 1.0.11"
}

provider aws {
    profile = "default"
    region  = "${var.server_region}"
}

module "game_servers" {
    source = "./game-servers"

    env = "${var.env}"
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.primary_availability_zone}"
    ark_server_image_id = "${var.ark_server_image_id}"
    ark_mapsets = var.ark_mapsets
    minecraft_maps = var.minecraft_maps
    valheim_maps = var.valheim_maps
    cluster_name = "${var.cluster_name}"
    subnet_id = var.subnet_id
    shared_package_version = var.shared_package_version
    ssh_sg_name = "${var.ssh_sg_name}"
    games_sg_name = "${var.games_sg_name}"
    node_sg_name = "${var.node_sg_name}"
}