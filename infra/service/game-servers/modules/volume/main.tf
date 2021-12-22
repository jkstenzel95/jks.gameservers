# the actual volume

resource "aws_ebs_volume" "volume" {
    availability_zone = "${var.server_region}b"
    size = var.volume_size
    type = "${var.type}"
    multi_attach_enabled = var.multi_attach_enabled

    tags = {
        Name = "jks-gs-${var.env}-${var.volume_identifier_name}-data-volume"
    }
}