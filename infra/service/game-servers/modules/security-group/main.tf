resource "aws_security_group" "base_sg" {
    name = "jks-gs-${var.env}-server_base-sg"
    description = "Allow HTTPS and SSH"

    ingress {
        description = "TLS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "jks-gs-${var.env}-server_base-sg"
  }
}