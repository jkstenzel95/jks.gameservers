variable "instance_identifier" {
    description = "the clause to be used in identifying the node group and associated resources (ex. gamename-mapname)"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
    default = "use2"
}

variable "env" {
    description = "the environment of the server resource set"
}