module "ark_node_group" {
    source = "./../node-group"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    availability_zone = "${var.availability_zone}"
    data_volume_id = "${var.ark_data_volume_id}" // TODO: support this being nonexistent?
    game_name = "Ark"
    map_name = "${var.ark_map_name}"
    instance_type = "c6i.4xlarge"
    resources_bucket_name = "${var.ark_resources_bucket_name}"
    backup_bucket_name = "${var.ark_backup_bucket_name}"
    security_group_ids = [ var.ssh_sg_id, var.base_sg_id, var.node_sg_id, var.ark_sg_id, var.minecraft_sg_id ]
    ark_server_image_id = "${var.ark_server_image_id}"
    game_policy_arns = [ var.ark_data_access_policy_arn, var.minecraft_data_access_policy_arn ]
    cluster_name = "${var.cluster_name}"
    subnet_id = var.subnet_id
    packages_bucket_name = var.packages_bucket_name
    shared_package_version = var.shared_package_version
    setup_at_launch = true
}