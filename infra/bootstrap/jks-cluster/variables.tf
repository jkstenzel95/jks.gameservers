variable region {
    description = "region to provision the cluster in"
}

variable region_shortname {
    description = "the shortname of the region to provision the cluster in"
}

variable primary_availability_zone {
    description =  "the name of the primary availability zone"
}

variable secondary_availability_zone {
    description =  "the name of the secondary availability zone"
}

variable "codebuild_role" {
  description = "The created role for CodeBuild"
}

variable "ssh_security_group_name" {
    description = "the pre-existing security group providing personal machine ssh access"
}

variable "cluster_name" {
    description = "the chosen name for the cluster"
}