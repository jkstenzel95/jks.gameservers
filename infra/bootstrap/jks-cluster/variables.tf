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