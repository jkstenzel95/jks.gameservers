module dev_preview_codebuild_project {
  source = "./codebuild"

  template_filename = "previewspec.yml"
  name = "jks-gs-dev-infra-preview"
  build_role = aws_iam_role.codebuild_role
  env = "dev"
}

module dev_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-dev-infra-deploy"
  build_role = aws_iam_role.codebuild_role
  env = "dev"
}

module prod_preview_codebuild_project {
  source = "./codebuild"

  template_filename = "previewspec.yml"
  name = "jks-gs-prod-infra-preview"
  build_role = aws_iam_role.codebuild_role
  env = "prod"
}

module prod_deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-prod-infra-deploy"
  build_role = aws_iam_role.codebuild_role
  env = "prod"
}

module infra_deployment_pipeline {
  source = "./codepipeline"

  name = "jks-gs-infra-pipeline"
  pipeline_role = aws_iam_role.codebuild_role
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  dev_preview_project_name = module.dev_preview_codebuild_project.name
  dev_deploy_project_name = module.dev_deploy_codebuild_project.name
  prod_preview_project_name = module.prod_preview_codebuild_project.name
  prod_deploy_project_name = module.prod_deploy_codebuild_project.name
}