resource "aws_security_group" "games_sg" {
    name = "jks-gs-games-sg"
    description = "Allow HTTPS and SSH"

    ingress {
        description = "TLS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    # Ark rules

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

    # Minecraft rules

    ingress {
        description = "Minecraft TCP Port"
        from_port = 25565
        to_port = 25585
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "Minecraft UDP Port"
        from_port = 25565
        to_port = 25585
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    # Valheim rules

    ingress {
        description = "Valheim TCP Port"
        from_port = 2456
        to_port = 2458
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "Valheim UDP Port"
        from_port = 2456
        to_port = 2458
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "jks-gs-serverbase-sg"
  }
}