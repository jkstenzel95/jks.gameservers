# the actual volume

resource "aws_ebs_volume" "volume" {
    availability_zone = "${var.server_region}a"
    size = var.volume_size
    type = "gp2"

    tags = {
        Name = "jks-gs-${var.env}-${var.region_shortname}-${var.volume_identifier_name}-data"
    }
}