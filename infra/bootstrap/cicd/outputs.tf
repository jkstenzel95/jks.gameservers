output "codebuild_role" {
  description = "The created role for CodeBuild"
  value = aws_iam_role.codebuild_role
}