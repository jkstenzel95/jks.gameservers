terraform {
    backend "s3" {
        bucket          = "jks-gameservers-state"
        key             = "global/s3/terraform.tfstate"
        region          = "us-east-2"

        dynamodb_table  = "jks-gameservers-state-locks"
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
}