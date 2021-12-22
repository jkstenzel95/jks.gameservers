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
    description = "size of the volume in GiB"
}

variable "type" {
    description = "type of the volume"
}

variable "multi_attach_enabled" {
    description = "whether the volume is permitted to attach to multiple instances"
}

variable "iops" {
    description = "provisioned iops"
}

variable "volume_identifier_name" {
    description = "the short identifier to be used in naming the volume"
}