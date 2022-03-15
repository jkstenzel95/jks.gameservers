variable "server_region" {
    description = "region to provision the server in"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "ark_map_name" {
    description = "the map for which the instance is created"
    default = "all"
}

variable availability_zone {
    description =  "the name of the availability zone"
}

variable "ark_data_volume_id" {
    description = "the id of the volume to attach to the instance"
}

variable ark_server_image_id {
    description = "the image ID (AMI) of the ark server being provisioned"
}

variable ssh_sg_id {
    description = "the id of the security group providing personal machine ssh access"
}

variable games_sg_id {
    description = "the id of the games security group"
}

variable node_sg_id {
    description = "the id of the node security group"
}

variable ark_resources_bucket_arn {
    description = "the bucket containing Ark server resources"
}

variable "ark_backup_bucket_arn" {
    description = "the bucket containing Ark server backups"
}

variable "packages_bucket_arn" {
    description = "the bucket containing the scripts and data files package"
}

variable ark_data_access_policy_arn {
    description = "the policy allowing access to ark data stores"
}

variable minecraft_data_access_policy_arn {
    description = "the policy allowing access to minecraft data stores"
}

variable valheim_data_access_policy_arn {
    description = "the policy allowing access to valheim data stores"
}

variable "packages_bucket_name" {
    description = "the name of the bucket containing the scripts and data files package"
}

variable "shared_package_version" {
    description = "the scripts and data files archive file version to download"
}

variable "ark_resources_bucket_name" {
    description = "the name of the bucket containing Ark server resources"
}

variable "ark_backup_bucket_name" {
    description = "the name of the bucket containing Ark server backups"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}