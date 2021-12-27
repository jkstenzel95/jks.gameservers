output "name" {
    description = "the name of the codebuild created"
    value = aws_codebuild_project.codebuild_project.name
}