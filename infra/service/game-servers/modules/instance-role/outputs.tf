output "name" {
    description = "The role name "
    value = aws_iam_role.instance_iam_role.name
}

output "arn" {
    description = "The role arn "
    value = aws_iam_role.instance_iam_role.arn
}