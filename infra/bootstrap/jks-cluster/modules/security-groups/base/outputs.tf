output "sg_id" {
  description = "the id of the created sercurity group"
  value = aws_security_group.base_sg.id
}