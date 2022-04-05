variable ark_server_image_id {
    description = "the image ID (AMI) of the ark server being provisioned"
}

variable ssh_sg_name {
    description = "the name of the security group providing personal machine ssh access"
}

variable games_sg_name {
    description = "the name of the games security group"
}

variable node_sg_name {
    description = "the name of the node security group"
}

variable ark_mapsets {
    description = "the list of ark mapsets to create resources for"
}

variable minecraft_maps {
    description = "the list of minecraft maps to create resources for"
}

variable valheim_maps {
    description = "the list of valheim maps to create resources for"
}

variable env {
    description = "the environment of the server resource set"
}

variable server_region {
    description = "region to provision the server in"
}

variable region_shortname {
    description = "the shortname of the region to provision the instance in"
}

variable availability_zone {
    description =  "the name of the availability zone"
}

variable "cluster_name" {
    description = "the name of the Kubernetes cluster"
}

variable subnet_id {
    description = "the subnet id"
}