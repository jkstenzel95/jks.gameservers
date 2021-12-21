module "shared_data_volume" {
    source = "./../ark-volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    volume_identifier_name = "arkshared"
}

module "scale_groups" {
    source = "./../ark-instance"

    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
    count = length(var.map_names)
    server_region = "${var.server_region}"
    data_volume_id = "${module.shared_data_volume.id}"
    map_name = var.map_names[count.index]
    use_spot_instance = "${var.use_spot_instance}"
}