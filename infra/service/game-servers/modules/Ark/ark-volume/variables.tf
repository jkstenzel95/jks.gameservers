variable "server_region" {
    description = "region to provision the server in"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "map_name" {
    description = "the name of the map to create resources for"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable availability_zone {
    description =  "the name of the availability zone"
}