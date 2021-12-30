# The pipeline for building and pushing the gameserver docker images

resource "aws_codepipeline" "gameservers_docker_codepipeline" {
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

    stage  {
        name = "Dev_Approval"
        
        action {
            name                = "Approval_dev"
            category            = "Approval"
            configuration = {
                "CustomData"    = "Approve the following docker publish"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            version             = "1"
        }
    }

    stage {
        name = "Build_Dev"

        action {
            name                = "Docker_build_dev"
            category            = "Test"
            configuration = {
                "ProjectName"   = "${var.dev_build_project_name}"
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
                "CustomData"    = "Approve the following docker publish"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            version             = "1"
        }
    }  

    stage {
        name = "Build_Prod"

        action {
            name                = "Docker_build_prod"
            category            = "Test"
            configuration = {
                "ProjectName"   = "${var.prod_build_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            output_artifacts    = []
            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
}