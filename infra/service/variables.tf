variable minecraft_map_names {
    description = "a list of names of minecraft maps to create"
    type = list(string)
}

variable valheim_map_names {
    description = "a list of names of valheim maps to create"
    type = list(string)
}

variable ark_server_image_id {
    description = "the image ID (AMI) of the Ark server being provisioned"
}

variable "ark_instance_type" {
    description = "the type of the instance to be used in the Ark fleet"
}

variable ssh_security_group {
    description = "the pre-existing security group providing personal machine ssh access"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "server_region" {
    description = "region to provision the server in"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}

variable primary_availability_zone {
    description =  "the name of the primary availability zone (where the vast majority of regions are provisioned)"
}

variable "shared_package_version" {
    description = "the scripts and data files archive file version to download"
}