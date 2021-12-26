output "id" {
    description = "the id of the subnet created for this cluster"
    value = aws_subnet.main.id
}