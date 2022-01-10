variable "server_region" {
    description = "region to provision the instance in"
}

variable "data_volume_id" {
    description = "the id of the volume to attach to the instance"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable availability_zone {
    description =  "the name of the availability zone"
}

variable "game_name" {
    description = "the game for which the instance is created"
}

variable "map_name" {
    description = "the map for which the instance is created"
}

variable "backup_bucket_name" {
    description = "the name of the bucket containing server backups"
}

variable "resources_bucket_name" {
    description = "the name of the bucket containing server resources"
}

variable "packages_bucket_name" {
    description = "the name of the bucket containing the scripts and data files package"
}

variable "shared_package_version" {
    description = "the scripts and data files archive file version to download"
}

variable "base_security_group_id" {
    description = "the base security group id to associate"
}

variable "additional_security_group_id" {
    description = "the game-specific security group id to associate"
}

variable "instance_type" {
    description = "the type of the instance to be used in the fleet"
}

variable "server_image_id" {
    description = "the image ID (AMI) of the servers being provisioned"
}

variable "ssh_security_group" {
    description = "the pre-existing security group providing personal machine ssh access"
}

variable "game_policy_arn" {
    description = "the arn for the game-specific policy for accessing kms, s3, etc"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}