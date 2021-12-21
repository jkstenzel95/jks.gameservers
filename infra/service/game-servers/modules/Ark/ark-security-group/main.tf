resource "aws_security_group" "ark_sg" {
    name = "jks-gs-${var.env}-ark-sg"
    description = "Allow HTTPS and SSH"

    ingress {
        description = "Ark Port"
        from_port = 7777
        to_port = 7777
        protocol = "tcp"
    }

    ingress {
        description = "Query Port"
        from_port = 27015
        to_port = 27015
        protocol = "udp"
    }

    ingress {
        description = "RCON Port"
        from_port = 32330
        to_port = 32330
        protocol = "tcp"
    }

  tags = {
    Name = "jks-gs-${var.env}-ark-sg"
  }
}