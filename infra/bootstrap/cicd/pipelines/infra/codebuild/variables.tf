variable "template_filename" {
    description = "the name of the file containing the buildspec (excluding the specs directory upward)"
}

variable "name" {
    description = "the name of the codebuild project"
}

variable "build_role" {
    description = "the AWS IAM role to use in the build stages"
}