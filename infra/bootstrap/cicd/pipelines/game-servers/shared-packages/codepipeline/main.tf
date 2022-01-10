# The pipeline for building and publishing the gameserver shared packages

resource "aws_codepipeline" "gameservers_packages_codepipeline" {
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
        name = "Approval"
        
        action {
            name                = "Approval"
            category            = "Approval"
            configuration = {
                "CustomData"    = "Approve the publishing of packages"
            }

            input_artifacts     = []
            output_artifacts    = []
            owner               = "AWS"
            provider            = "Manual"
            version             = "1"
        }
    }

    stage {
        name = "Publish"

        action {
            name                = "Packages_publish"
            category            = "Build"
            configuration = {
                "ProjectName"   = "${var.publish_project_name}"
            }

            input_artifacts     = ["SourceArtifact"]
            output_artifacts    = []
            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
        }
    }
}