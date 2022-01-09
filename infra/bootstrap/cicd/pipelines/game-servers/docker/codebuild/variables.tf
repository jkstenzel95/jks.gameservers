variable "template_filename" {
    description = "the name of the file containing the buildspec (excluding the specs directory upward)"
}

variable "name" {
    description = "the name of the codebuild project"
}

variable "build_role_arn" {
    description = "the AWS IAM role to use in the build stages"
}

variable "env" {
    description = "the environment of the server resource set"
}

variable "privileged_mode" {
    description = "Whether to enable running the Docker daemon inside a Docker container."
    default = false
}