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

variable "game_name" {
    description = "the game for which the instance is created"
}

variable "map_name" {
    description = "the map for which the instance is created"
}

variable "volume_size" {
    description = "size of the volume in GiB"
}

variable "type" {
    description = "type of the volume"
}

variable "iops" {
    description = "provisioned iops"
}