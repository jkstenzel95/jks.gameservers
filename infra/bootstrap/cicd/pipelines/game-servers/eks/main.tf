module "artifact_bucket" {
  source = "./../../../artifact_bucket"

  pipeline_identifier = "infra"
}

module dev_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-dev-infra-deploy"
  build_role_arn = var.role_arn
  env = "dev"
}

module prod_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-prod-infra-deploy"
  build_role_arn = var.role_arn
  env = "prod"
}

module infra_deployment_pipeline {
  source = "./codepipeline"

  name = "jks-gs-infra-pipeline"
  pipeline_role_arn = var.role_arn
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  dev_deploy_project_name = module.dev_deploy_codebuild_project.name
  prod_deploy_project_name = module.prod_deploy_codebuild_project.name
}