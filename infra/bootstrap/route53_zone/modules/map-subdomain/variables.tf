variable "main_zone_id" {
  description = "the id of the main hosted zone"
}

variable domain_name {
    description = "the name of the top level domain to use"
}

variable "game_name" {
  description = "the name of the game for this subdomain"
}

variable "map_name" {
  description = "the name of the map for this subdomain"
}

variable "name_servers" {
    description = "the name servers to use with the subdomain"
}