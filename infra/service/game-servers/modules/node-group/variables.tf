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

variable "setup_at_launch" {
    description = "whether the setup should happen by the node at launch instead of the pod"
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

variable "instance_type" {
    description = "the type of the instance to be used in the fleet"
}

variable "server_image_id" {
    description = "the image ID (AMI) of the servers being provisioned"
}

variable ssh_sg_id {
    description = "the id of the security group providing personal machine ssh access"
}

variable base_sg_id {
    description = "the id of the base security group"
}

variable node_sg_id {
    description = "the id of the node security group"
}

variable game_sg_id {
    description = "the id of the game security group"
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