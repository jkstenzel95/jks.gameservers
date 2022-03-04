variable "game_name" {
    description = "the game for which the instance is created"
}

variable "map_name" {
    description = "the map for which the instance is created"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
    default = "use2"
}

variable "env" {
    description = "the environment of the server resource set"
}