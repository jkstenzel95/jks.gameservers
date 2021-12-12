variable "server_region" {
    description = "region to provision the instance in"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "map_names" {
    description = "the set of maps to be added to the Ark cluster"
    type = list(string)
}