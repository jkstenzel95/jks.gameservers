terraform {
    backend "s3" {
        bucket          = "jks-gs-shared-state"
        key             = "global/s3/terraform.tfstate"
        region          = "us-east-2"

        dynamodb_table  = "jks-gs-shared-state-locks"
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
    region  = "${var.region}"
}

module "cicd" {
    source = "./cicd"
}

module "jks_cluster" {
    source = "./jks-cluster"

    region = "us-east-2"
    region_shortname = "use2"
    primary_availability_zone = "us-east-2a"
    secondary_availability_zone = "us-east-2b"
}