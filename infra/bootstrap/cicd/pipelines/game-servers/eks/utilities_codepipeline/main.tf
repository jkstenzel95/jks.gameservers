# The pipeline for testing (terraform plan) and deploying game server eks

resource "aws_codepipeline" "gameservers_eks_utilities_codepipeline" {
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
        name = "Dry_Run"

        action {
            name                = "dry_run"
            category            = "Test"
            configuration = {
                "ProjectName"   = "${var.preview_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            
            output_artifacts    = []

            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
  
    stage  {
        name = "Approval"
        
        action {
            name                = "approval"
            category            = "Approval"
            configuration = {
                "CustomData"    = "Approve the following eks deployment"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            version             = "1"
        }
    }  

    stage {
        name = "Deploy"

        action {
            name                = "deploy"
            category            = "Build"
            configuration = {
                "ProjectName"   = "${var.deploy_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            
            output_artifacts    = []

            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
}