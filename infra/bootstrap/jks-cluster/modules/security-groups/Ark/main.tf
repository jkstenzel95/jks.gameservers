resource "aws_security_group" "ark_sg" {
    name = "jks-gs-ark-sg"
    description = "Allow HTTPS and SSH"

    ingress {
        description = "Ark Port"
        from_port = 7777
        to_port = 7818
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "Query Port"
        from_port = 27015
        to_port = 27055
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "RCON Port"
        from_port = 32330
        to_port = 32370
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "jks-gs-ark-sg"
  }
}