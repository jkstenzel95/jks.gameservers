variable "template_filename" {
    description = "the name of the file containing the buildspec (excluding the specs directory upward)"
}

variable "name" {
    description = "the name of the codebuild project"
}

variable "is_test" {
    description = "whether this is just a dry run"
    default = false
}

variable "build_role_arn" {
    description = "the AWS IAM role to use in the build stages"
}

variable "region_shortname" {
    description = "the shortname of the region to provision the instance in"
    default = "use2"
}

variable "env" {
    description = "the environment of the server resource set"
}