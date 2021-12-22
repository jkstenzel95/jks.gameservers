module "instance" {
    source = "./../../game-instance"

    instance_type = "a1.xlarge"
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    data_volume_id = "${var.data_volume_id}"
    game_name = "Ark"
    map_name = "${var.map_name}"
    base_security_group_id = "${var.base_security_group_id}"
    additional_security_group_id = "${var.additional_security_group_id}"
    server_image_id = "${var.server_image_id}"
    use_spot_instance = "${var.use_spot_instance}"
}