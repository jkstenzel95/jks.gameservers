module "artifact_bucket" {
  source = "./../../../artifact_bucket"

  pipeline_identifier = "gameservers-packages"
}

module publish_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-gameserver-packages-publish"
  build_role_arn = var.role_arn
  env = "prod"
}

module gameservers_packages_pipeline {
  source = "./codepipeline"

  name = "jks-gs-gameservers-packages-pipeline"
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  publish_project_name = module.publish_codebuild_project.name
  pipeline_role_arn = var.role_arn
}