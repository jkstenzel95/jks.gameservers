module "ark_sg" {
    source = "./../ark-security-group"

    env = "${var.env}"
}

module "shared_data_volume" {
    source = "./../ark-volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    volume_identifier_name = "arkshared"
}

module "ark_instances" {
    source = "./../ark-instance"

    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
    count = length(var.map_names)
    server_region = "${var.server_region}"
    data_volume_id = "${module.shared_data_volume.id}"
    map_name = var.map_names[count.index]
    base_security_group_id = "${var.shared_sg_id}"
    additional_security_group_id = "${module.ark_sg.id}"
    server_image_id = "${var.server_image_id}"
    use_spot_instance = "${var.use_spot_instance}"
}