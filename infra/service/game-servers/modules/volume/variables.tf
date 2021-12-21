variable "server_region" {
    description = "region to provision the instance in"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "volume_size" {
    description = "size of the volumen in GiB"
}

variable "volume_identifier_name" {
    description = "the short identifier to be used in naming the volume"
}