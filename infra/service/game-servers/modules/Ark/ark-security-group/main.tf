resource "aws_security_group" "ark_sg" {
    name = "jks-gs-${var.env}-ark-sg"
    description = "Allow HTTPS and SSH"

    ingress {
        description = "Ark Port"
        from_port = 7777
        to_port = 7777
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "Ark Port 2"
        from_port = 7778
        to_port = 7778
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "Query Port"
        from_port = 27015
        to_port = 27015
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "RCON Port"
        from_port = 32330
        to_port = 32330
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "jks-gs-${var.env}-ark-sg"
  }
}