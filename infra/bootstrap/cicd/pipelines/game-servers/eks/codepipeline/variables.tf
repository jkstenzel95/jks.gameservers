variable "dev_preview_project_name" {
    description = "the name of the codebuild project for previewing dev deployment"
}

variable "dev_deploy_project_name" {
    description = "the name of the codebuild project for dev deployment"
}

variable "prod_preview_project_name" {
    description = "the name of the codebuild project for previewing prod deployment"
}

variable "prod_deploy_project_name" {
    description = "the name of the codebuild project for prod deployment"
}

variable "repository_name" {
    description = "the name of the repository to use as source"
    default = "jks.gameservers"
}

variable "repository_branch" {
    description = "the name of the branch to use as source"
    default = "main"
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