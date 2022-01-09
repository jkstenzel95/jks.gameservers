module "artifact_bucket" {
  source = "./../../../artifact_bucket"

  pipeline_identifier = "gameservers-docker"
}

module dev_build_codebuild_project {
  source = "./codebuild"

  template_filename = "buildspec.yml"
  name = "jks-gs-dev-gameserver-docker-build"
  build_role_arn = var.role_arn
  env = "dev"
  privileged_mode = true
}

module prod_build_codebuild_project {
  source = "./codebuild"

  template_filename = "buildspec.yml"
  name = "jks-gs-prod-gameserver-docker-build"
  build_role_arn = var.role_arn
  env = "prod"
  privileged_mode = true
}

module gameservers_docker_pipeline {
  source = "./codepipeline"

  name = "jks-gs-gameservers-docker-pipeline"
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  dev_build_project_name = module.dev_build_codebuild_project.name
  prod_build_project_name = module.prod_build_codebuild_project.name
  pipeline_role_arn = var.role_arn
}