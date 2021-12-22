variable ark_map_names {
    description = "a list of names of ark maps to create"
    type = list(string)
}

variable minecraft_map_names {
    description = "a list of names of minecraft maps to create"
    type = list(string)
}

variable valheim_map_names {
    description = "a list of names of valheim maps to create"
    type = list(string)
}

variable server_image_id {
    description = "the image ID (AMI) of the servers being provisioned"
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

variable "use_spot_instance" {
    description = "Use a persistent spot request for hosting instead of dedicated instances"
    type = bool
    default = true
}