module "ark_cluster" {
    source = "./modules/Ark/ark-cluster"

    map_names = var.ark_map_names
    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
}