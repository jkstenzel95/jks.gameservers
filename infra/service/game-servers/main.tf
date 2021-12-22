module "shared_sg" {
    source = "./modules/security-group"

    env = "${var.env}"
}

module "ark_cluster" {
    source = "./modules/Ark/ark-cluster"

    map_names = var.ark_map_names
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    shared_sg_id = module.shared_sg.id
    server_image_id = "${var.server_image_id}"
    use_spot_instance = var.use_spot_instance
}