# The pipeline for testing (terraform plan) and deploying game server infra

resource "aws_codepipeline" "infra_codepipeline" {
    name            = "${var.name}"
    role_arn        = var.pipeline_role.arn

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
            run_order                   = 1
            version                     = "1"
        }
    }

    stage {
        name = "Preview"

        action {
            name                = "Terraform_plan"
            category            = "Test"
            configuration = {
                "ProjectName"   = "${var.preview_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            output_artifacts    = []
            owner               = "AWS"
            provider            = "CodeBuild"
            run_order           = 2
            version             = "1"
        }
    }
  
    stage  {
        name = "Approval"
        
        action {
            name                = "Approval"
            category            = "Approval"
            configuration = {
                "CustomData"    = "Approve the following infra deployment"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            run_order           = 3
            version             = "1"
        }
    }  

    stage {
        name = "Deploy"

        action {
            name                = "Terraform_apply"
            category            = "Build"
            configuration = {
                "ProjectName"   = "${var.deploy_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            
            output_artifacts    = []

            owner               = "AWS"
            provider            = "CodeBuild"
            run_order           = 4
            version             = "1"
        }
    }
}