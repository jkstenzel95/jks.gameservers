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

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "game_name" {
    description = "the game for which the instance is created"
}

variable "map_name" {
    description = "the map for which the instance is created"
}

variable "base_security_group_id" {
    description = "the base security group id to associate"
}

variable "additional_security_group_id" {
    description = "the game-specific security group id to associate"
}

variable server_image_id {
    description = "the image ID (AMI) of the servers being provisioned"
}

variable "use_spot_instance" {
    description = "Use a persistent spot request for hosting instead of dedicated instances"
    type = bool
    default = true
}