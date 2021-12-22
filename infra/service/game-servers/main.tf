module "shared_sg" {
    source = "./modules/security-group"

    env = "${var.env}"
}

module "ark_cluster" {
    source = "./modules/Ark/ark-cluster"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.availability_zone}"
    env = "${var.env}"
    shared_sg_id = module.shared_sg.id
    server_image_id = "${var.server_image_id}"
    ssh_security_group = "${var.ssh_security_group}"
    use_spot_instance = var.use_spot_instance
}