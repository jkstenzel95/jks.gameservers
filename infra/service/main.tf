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

module "game-servers" {
    source = "./game-servers"

    ark_map_names = "${var.ark_map_names}"
    minecraft_map_names = "${var.minecraft_map_names}"
    valheim_map_names = "${var.valheim_map_names}"
    env = "${var.env}"
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
}