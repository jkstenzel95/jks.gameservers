module "ark_scale_group" {
    source = "../../game-instance"

    instance_type = "a1.xlarge"
    server_region = "${var.server_region}"
    data_volume_id = "${var.data_volume_id}"
    game_name = "Ark"
    map_name = "${var.map_name}"
}