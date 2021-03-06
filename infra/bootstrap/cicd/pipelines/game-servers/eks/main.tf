module "artifact_bucket" {
  source = "./../../../artifact_bucket"

  pipeline_identifier = "gameserver-eks"
}

module dev_preview_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-dev-gameserver-eks-preview"
  is_test = true
  build_role_arn = var.role_arn
  env = "dev"
}

module dev_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-dev-gameserver-eks-deploy"
  build_role_arn = var.role_arn
  env = "dev"
}

module prod_preview_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-prod-gameserver-eks-preview"
  is_test = true
  build_role_arn = var.role_arn
  env = "prod"
}

module prod_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-prod-gameserver-eks-deploy"
  build_role_arn = var.role_arn
  env = "prod"
}

module gameserver_eks_deployment_pipeline {
  source = "./codepipeline"

  name = "jks-gs-gameserver-eks-pipeline"
  pipeline_role_arn = var.role_arn
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  dev_deploy_project_name = module.dev_deploy_codebuild_project.name
  dev_preview_project_name = module.dev_preview_codebuild_project.name
  prod_deploy_project_name = module.prod_deploy_codebuild_project.name
  prod_preview_project_name = module.prod_preview_codebuild_project.name
}

module utilities_preview_codebuild_project {
  source = "./codebuild"

  template_filename = "utilitiesdeployspec.yml"
  name = "jks-gs-dev-gameserver-eks-utilities-preview"
  is_test = true
  build_role_arn = var.role_arn
  env = "dev"
}

module utilities_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "utilitiesdeployspec.yml"
  name = "jks-gs-dev-gameserver-eks-utilities-deploy"
  build_role_arn = var.role_arn
  env = "dev"
}

module gameserver_eks_utilities_deployment_pipeline {
  source = "./utilities_codepipeline"

  name = "jks-gs-gameserver-eks-utilities-pipeline"
  pipeline_role_arn = var.role_arn
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  deploy_project_name = module.utilities_deploy_codebuild_project.name
  preview_project_name = module.utilities_preview_codebuild_project.name
}