module "shared_sg" {
    source = "./modules/security-group"

    env = "${var.env}"
}

module "ark_resources" {
    source = "./modules/Ark/ark-resources"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.availability_zone}"
    env = "${var.env}"
    shared_sg_id = module.shared_sg.id
    server_image_id = "${var.ark_server_image_id}"
    instance_type = "${var.ark_instance_type}"
    ssh_security_group = "${var.ssh_security_group}"
    cluster_name = "${var.cluster_name}"
    subnet_id = var.subnet_id
}