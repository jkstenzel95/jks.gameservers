module "shared_data_volume" {
    source = "../ark-volume"

    server_region = "${var.server_region}"
    volume_identifier_name = "arkshared"
}

module "instances" {
    source = "../ark-instance"

    count = length(var.map_names)
    server_region = "${var.server_region}"
    data_volume_id = "${module.shared_data_volume.id}"
    map_name = var.map_names[count.index]
}