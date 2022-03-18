variable "region_shortname" {
    description = "the shortname of the region to provision the server deployment in"
}

variable "env" {
    description = "the environment of the server deployment"
}

variable "game_name" {
    description = "the game for which the bucket is created"
}

variable "map_name" {
    description = "the name of the map to create the bucket for"
    default = ""
}

variable "purpose" {
    description = "the purpose of the bucket"
}