variable "server_region" {
    description = "region to provision the instance in"
}

variable "map_names" {
    description = "the set of maps to be added to the Ark cluster"
    type = list(string)
}