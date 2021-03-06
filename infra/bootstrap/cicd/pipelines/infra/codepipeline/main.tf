# The pipeline for testing (terraform plan) and deploying game server infra

resource "aws_codepipeline" "infra_codepipeline" {
    name            = "${var.name}"
    role_arn        = var.pipeline_role_arn

    artifact_store {
        location = var.artifacts_bucket_name
        type     = "S3"
  }

    stage {
        name = "Source"

        action {
            name                        = "Source"
            category                    = "Source"
            configuration = {
                "ConnectionArn"         = var.github_connection_arn
                "FullRepositoryId"      = "${var.repository_owner}/${var.repository_name}"
                "BranchName"            = var.repository_branch
            }

            output_artifacts            = ["SourceArtifact"]
            owner                       = "AWS"
            provider                    = "CodeStarSourceConnection"
            version                     = "1"
        }
    }

    stage {
        name = "Preview_Dev"

        action {
            name                = "Terraform_plan_dev"
            category            = "Test"
            configuration = {
                "ProjectName"   = "${var.dev_preview_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            output_artifacts    = []
            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
  
    stage  {
        name = "Dev_Approval"
        
        action {
            name                = "Approval_dev"
            category            = "Approval"
            configuration = {
                "CustomData"    = "Approve the following infra deployment"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            version             = "1"
        }
    }  

    stage {
        name = "Deploy_Dev"

        action {
            name                = "Terraform_apply_dev"
            category            = "Build"
            configuration = {
                "ProjectName"   = "${var.dev_deploy_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            
            output_artifacts    = []

            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }

    stage {
        name = "Preview_Prod"

        action {
            name                = "Terraform_plan_prod"
            category            = "Test"
            configuration = {
                "ProjectName"   = "${var.prod_preview_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            output_artifacts    = []
            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
  
    stage  {
        name = "Prod_Approval"
        
        action {
            name                = "Approval_prod"
            category            = "Approval"
            configuration = {
                "CustomData"    = "Approve the following infra deployment"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            version             = "1"
        }
    }  

    stage {
        name = "Deploy_Prod"

        action {
            name                = "Terraform_apply_prod"
            category            = "Build"
            configuration = {
                "ProjectName"   = "${var.prod_deploy_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            
            output_artifacts    = []

            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
}