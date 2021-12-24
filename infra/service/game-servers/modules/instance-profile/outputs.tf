output "name" {
    description = "The profile name "
    value = aws_iam_instance_profile.instance_iam_profile.name
}

output "role_name" {
    description = "The name of the underlying IAM role"
    value = aws_iam_policy.policy.name
}