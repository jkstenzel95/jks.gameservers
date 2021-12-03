variable "instance_type" {
    description = "the type of instance that will run the server"
    default = "a1.xlarge"
}

variable "server_region" {
    description = "region to provision the instance in"
}

variable "data_volume_id" {
    description = "the id of the volume to attach to the instance"
}

variable "game_name" {
    description = "the game for which the instance is created"
}

variable "map_name" {
    description = "the map for which the instance is created"
}