resource "aws_codebuild_project" "codebuild_project" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "${var.name}"
  queued_timeout = 480
  service_role   = var.build_role_arn

  artifacts {
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = var.buildspec.rendered
    type                = "CODEPIPELINE"
  }
}