module "volume" {
    volume_identifier_name = "${var.volume_identifier_name}"
    source = "../../spot-volume"

    server_region = "${var.server_region}"
    #TODO it needs to be a lot bigger than this
    volume_size = 50

}