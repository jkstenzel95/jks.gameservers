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

variable "shared_sg_id" {
    description = "the base security group id"
}

variable server_image_id {
    description = "the image ID (AMI) of the servers being provisioned"
}

variable ssh_security_group {
    description = "the pre-existing security group providing personal machine ssh access"
}

variable "use_spot_instance" {
    description = "use a persistent spot request for hosting instead of dedicated instances"
    type = bool
    default = true
}