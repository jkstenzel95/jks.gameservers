module "volume" {
    volume_identifier_name = "${var.volume_identifier_name}"
    source = "./../../volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    volume_size = 200
    type = "io1"
    multi_attach_enabled = true
    iops = 200
}