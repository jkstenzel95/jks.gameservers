module "volume" {
    source = "./../../volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Ark"
    map_name = "all"
    availability_zone = "${var.availability_zone}"
    volume_size = 200
    type = "gp2"
    iops = null
}