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

module "jks_cluster" {
    source = "./jks-cluster"

    env = "${var.env}"
    region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    primary_availability_zone = "${var.primary_availability_zone}"
    secondary_availability_zone = "${var.secondary_availability_zone}"
}

module "game_servers" {
    source = "./game-servers"

    minecraft_map_names = "${var.minecraft_map_names}"
    valheim_map_names = "${var.valheim_map_names}"
    env = "${var.env}"
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.primary_availability_zone}"
    ark_server_image_id = "${var.ark_server_image_id}"
    ark_instance_type = "${var.ark_instance_type}"
    ssh_security_group = "${var.ssh_security_group}"
    cluster_name = "${module.jks_cluster.name}"
    subnet_id = module.jks_cluster.primary_subnet_id
}