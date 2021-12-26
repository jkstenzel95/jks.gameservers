resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_default_vpc.default.id
  availability_zone = "${var.availability_zone}"
  cidr_block = "0.0.0.0/0"

  tags = {
    Name = "Main"
    Resource = "kubernetes.io/cluster/${var.cluster_name}"
  }
}