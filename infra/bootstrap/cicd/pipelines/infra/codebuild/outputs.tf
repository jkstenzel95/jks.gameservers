output "name" {
    description = "the name of the cloudbuild created"
    value = aws_codebuild_project.codebuild_project.name
}