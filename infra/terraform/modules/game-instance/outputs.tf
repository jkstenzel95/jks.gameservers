output "instance_autoscale_group" {
    description = "the instance created"
    value = aws_autoscaling_group.spot_instance_autoscale_group
}