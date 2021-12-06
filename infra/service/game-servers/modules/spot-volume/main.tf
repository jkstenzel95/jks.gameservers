# the actual volume

resource "aws_ebs_volume" "volume" {
    availability_zone = "${var.server_region}a"
    size = var.volume_size
    type = "gp2"

    tags = {
        Name = "jks-gameservers-${var.volume_identifier_name}-data-volume"
    }
}