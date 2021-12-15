locals {
    BUCKET_NAME = "jks-gs-${var.env}-${var.region_shortname}-state"
    DYNAMODB_NAME = "jks-gs-${var.env}-${var.region_shortname}-state-locks"
}

terraform {
    backend "s3" {
        bucket          = "${local.BUCKET_NAME}"
        key             = "global/s3/terraform.tfstate"
        region          = "us-east-2"

        dynamodb_table  = "${local.DYNAMODB_NAME}"
        encrypt         = true
    }
    
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.68"
        }
    }

    required_version = ">= 1.0.11"
}

provider aws {
    profile = "default"
    region  = "${var.server_region}"
}

module "ark_cluster" {
    source = "./modules/Ark/ark-cluster"

    map_names = var.ark_map_names
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
}