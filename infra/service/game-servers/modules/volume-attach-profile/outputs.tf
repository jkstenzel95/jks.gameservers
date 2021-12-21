output "name" {
    description = "The profile name for volume attaching"
    value = aws_iam_instance_profile.spot_launch_iam_profile.name
}