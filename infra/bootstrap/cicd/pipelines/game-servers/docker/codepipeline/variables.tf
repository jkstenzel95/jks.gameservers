variable "dev_build_project_name" {
    description = "the name of the codebuild project for dev building"
}

variable "prod_build_project_name" {
    description = "the name of the codebuild project for prod building"
}

variable "repository_name" {
    description = "the name of the repository to use as source"
    default = "jks.gameservers"
}

variable "repository_branch" {
    description = "the name of the branch to use as source"
    default = "user/jastenze/initial-commit"
}

variable "repository_owner" {
    description = "the owner of the repository to use as source"
    default = "jkstenzel95"
}

variable "name" {
    description = "the name of the codepipeline"
}

variable "pipeline_role_arn" {
    description = "the arn of the AWS IAM role to use in the pipeline"
}

variable "artifacts_bucket_name" {
    description = "the name of the artifacts bucket"
}

variable "github_connection_arn" {
    description = "the arn of the github connection"
}