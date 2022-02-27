resource "aws_security_group" "minecraft_sg" {
    name = "jks-gs-minecraft-sg"
    description = "Allow minecraft server traffic"

    ingress {
        description = "Minecraft TCP Port"
        from_port = 25565
        to_port = 25565
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "Minecraft UDP Port"
        from_port = 25565
        to_port = 25565
        protocol = "udp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    // TODO: RCON Port?

  tags = {
    Name = "jks-gs-minecraft-sg"
  }
}