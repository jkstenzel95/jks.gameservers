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

module "resources_bucket" {
    source = "./../../s3-bucket"

    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Ark"
    purpose = "gameresources"
}

module "backup_bucket" {
    source = "./../../s3-bucket"

    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Ark"
    purpose = "backup"
}

module "ark_node_group" {
    source = "./../ark-node-group"

    env = "${var.env}"
    region_shortname = "${var.region_shortname}"
    server_region = "${var.server_region}"
    availability_zone = "${var.availability_zone}"
    data_volume_id = "${module.shared_data_volume.id}"
    base_security_group_id = "${var.shared_sg_id}"
    additional_security_group_id = "${module.ark_sg.id}"
    server_image_id = "${var.server_image_id}"
    instance_type = "${var.instance_type}"
    ssh_security_group = "${var.ssh_security_group}"
    resources_bucket_arn = module.resources_bucket.arn
    resources_bucket_name = module.resources_bucket.name
    backup_bucket_arn = module.resources_bucket.arn
    backup_bucket_name = module.backup_bucket.name
    packages_bucket_name = var.packages_bucket_name
    cluster_name = "${var.cluster_name}"
    subnet_id = var.subnet_id
    shared_package_version =  var.shared_package_version
}