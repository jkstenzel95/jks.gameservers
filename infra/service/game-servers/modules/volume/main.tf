# the actual volume

resource "aws_ebs_volume" "volume" {
    availability_zone = "${var.availability_zone}"
    size = var.volume_size
    type = "${var.type}"
    iops = var.iops

    tags = {
        Name = "jks-gs-${var.env}-${var.game_name}-${var.map_name}-data-volume"
    }
}