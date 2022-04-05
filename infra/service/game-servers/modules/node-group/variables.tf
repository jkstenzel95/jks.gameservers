variable "server_region" {
    description = "region to provision the instance in"
}

variable "data_volume_id" {
    description = "the id of the volume to attach to the instance at launch, if var.setup_at_launch"
    default = ""
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "domain" {
    description = "the top level domain"
    default = "winecraft.io"
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

variable "instance_identifier" {
    description = "the clause to be used in identifying the node group and associated resources (ex. gamename-mapname)"
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

variable "public_ip_name" {
    description = "the name of the public IP resource"
}

variable "instance_type" {
    description = "the type of the instance to be used in the fleet"
}

variable "server_image_id" {
    description = "the image ID (AMI) of the server being provisioned"
}

variable security_group_ids {
    description = "the ids of the security groups to attach to the node group"
}

variable "game_policy_arns" {
    description = "the arns for the game-specific policies for accessing kms, s3, etc"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}