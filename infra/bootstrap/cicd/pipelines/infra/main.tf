terraform {
    backend "s3" {
        bucket          = "jks-gameservers-state"
        key             = "global/s3/terraform.tfstate"
        region          = "us-east-2"

        dynamodb_table  = "jks-gameservers-state-locks"
        encrypt         = true
    }
    
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.68"
        }
    }

    required_version = ">= 1.0.11"
}

provider aws {
    profile = "default"
    region  = "${var.region}"
}

resource "aws_iam_role" "codebuild_role" {
  name = "jks_gameservers_codebuild_deploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

module artifact_bucket {
  source = "./../../artifact_bucket"
}

module preview_codebuild_project {
  source = "./codebuild"

  template_filename = "previewspec.yml"
  name = "jks-gs-infra-preview"
  build_role = aws_iam_role.codebuild_role
}

module deploy_codebuild_project {
  source = "./codebuild"

  template_filename = "deployspec.yml"
  name = "jks-gs-infra-deploy"
  build_role = aws_iam_role.codebuild_role
}

module infra_deployment_pipeline {
  source = "./codepipeline"

  name = "jks-gs-infra-pipeline"
  pipeline_role = aws_iam_role.codebuild_role
  artifacts_bucket_name = module.artifact_bucket.name
  github_connection_arn = var.github_connection_arn
  preview_project_name = module.preview_codebuild_project.name
  deploy_project_name = module.deploy_codebuild_project.name
}