variable "server_region" {
    description = "region to provision the server in"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "map_name" {
    description = "the map for which the instance is created"
    default = "all"
}

variable availability_zone {
    description =  "the name of the availability zone"
}

variable "data_volume_id" {
    description = "the id of the volume to attach to the instance"
}

variable "base_security_group_id" {
    description = "the base security group id to associate"
}

variable "additional_security_group_id" {
    description = "the game-specific security group id to associate"
}

variable server_image_id {
    description = "the image ID (AMI) of the servers being provisioned"
}

variable "instance_type" {
    description = "the type of the instance to be used in the fleet"
}

variable ssh_security_group {
    description = "the pre-existing security group providing personal machine ssh access"
}

variable resources_bucket_arn {
    description = "the bucket containing Ark server resources"
}

variable resources_bucket_name {
    description = "the name of the bucket containing Ark server resources"
}

variable backup_bucket_arn {
    description = "the bucket containing Ark server backups"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}