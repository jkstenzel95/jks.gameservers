variable "server_region" {
    description = "region to provision the instance in"
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

variable ssh_sg_id {
    description = "the id of the security group providing personal machine ssh access"
}

variable base_sg_id {
    description = "the id of the base security group"
}

variable node_sg_id {
    description = "the id of the node security group"
}

variable ark_sg_id {
    description = "the id of the ark security group"
}

variable server_image_id {
    description = "the image ID (AMI) of the servers being provisioned"
}

variable "instance_type" {
    description = "the type of the instance to be used in the fleet"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}

variable "packages_bucket_arn" {
    description = "the bucket containing the scripts and data files package"
}

variable "packages_bucket_name" {
    description = "the name of the bucket containing the scripts and data files package"
}

variable "shared_package_version" {
    description = "the scripts and data files archive file version to download"
}