module "volume" {
    volume_identifier_name = "${var.volume_identifier_name}"
    source = "./../../spot-volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    #TODO it needs to be a lot bigger than this
    volume_size = 50

}