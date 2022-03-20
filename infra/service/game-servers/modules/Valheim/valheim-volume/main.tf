# TODO: A lot of duplication between games here. Just generalize the disk sizes as variables somewhere.
module "volume" {
    source = "./../../volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Valheim"
    map_name = "${var.map_name}"
    availability_zone = "${var.availability_zone}"
    volume_size = 16
    type = "gp2"
    iops = null
}