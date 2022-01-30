variable "env" {
    description = "the environment of the server resource set"
}

variable "game_name" {
    description = "the game for which the instance is created"
}

variable "map_name" {
    description = "the map for which the instance is created"
}

variable region_shortname {
    description = "shortname of the region to provision the server in"
}

variable dns_name {
    description = "the DNS being assigned to the elastic IP"
    default = "winecraft.io"
}

variable use_map_in_name {
    description = "whether to use the map name in the subdomain"
    default = true
}