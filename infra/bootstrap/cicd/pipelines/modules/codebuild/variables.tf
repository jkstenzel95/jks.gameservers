variable "name" {
    description = "the name of the codebuild project"
}

variable "build_role_arn" {
    description = "the AWS IAM role to use in the build stages"
}

variable "buildspec" {
    description = "the buildspec to be assigned to the codebuild"
}

variable "image" {
    description = "the image to use in the build step"
    default = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
}

variable "privileged_mode" {
    description = "Whether to enable running the Docker daemon inside a Docker container."
    default = false
}