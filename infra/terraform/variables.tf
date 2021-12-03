variable ark_map_names {
    description = "a list of names of ark maps to create"
    type = list(string)
    default = [ "TheIsland" ]
}

variable minecraft_map_names {
    description = "a list of names of minecraft maps to create"
    type = list(string)
    default = [ "default" ]
}

variable valheim_map_names {
    description = "a list of names of valheim maps to create"
    type = list(string)
    default = [ "default" ]
}

variable "server_region" {
    description = "region to provision the server in"
}