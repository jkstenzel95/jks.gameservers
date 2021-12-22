module "ark_sg" {
    source = "./../ark-security-group"

    env = "${var.env}"
}

module "shared_data_volume" {
    source = "./../ark-volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    availability_zone = "${var.availability_zone}"
}

module "ark_instances" {
    source = "./../ark-instance"

    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
    server_region = "${var.server_region}"
    availability_zone = "${var.availability_zone}"
    data_volume_id = "${module.shared_data_volume.id}"
    base_security_group_id = "${var.shared_sg_id}"
    additional_security_group_id = "${module.ark_sg.id}"
    server_image_id = "${var.server_image_id}"
    ssh_security_group = "${var.ssh_security_group}"
    use_spot_instance = "${var.use_spot_instance}"
}