module "instance" {
    source = "./../../game-instance"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    availability_zone = "${var.availability_zone}"
    data_volume_id = "${var.data_volume_id}"
    game_name = "Ark"
    map_name = "all"
    instance_type = "a1.2xlarge"
    base_security_group_id = "${var.base_security_group_id}"
    additional_security_group_id = "${var.additional_security_group_id}"
    server_image_id = "${var.server_image_id}"
    ssh_security_group = "${var.ssh_security_group}"
    use_spot_instance = "${var.use_spot_instance}"
}