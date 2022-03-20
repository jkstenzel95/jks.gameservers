locals {
  ark_data_access_policy_arns_map = zipmap(var.ark_mapsets, module.ark_resources.data_access_policy_arns)
  ark_resources_bucket_arns_map = zipmap(var.ark_mapsets, module.ark_resources.resources_bucket_arns)
  ark_resources_bucket_names_map = zipmap(var.ark_mapsets, module.ark_resources.resources_bucket_names)
  ark_backup_bucket_arns_map = zipmap(var.ark_mapsets, module.ark_resources.backup_bucket_arns)
  ark_backup_bucket_names_map = zipmap(var.ark_mapsets, module.ark_resources.backup_bucket_names)
  ark_data_volume_ids_map = zipmap(var.ark_mapsets, module.ark_resources.shared_data_volume_ids)
  ark_main_mapset = "all"
}

resource "aws_s3_bucket" "packages_bucket" {
  bucket = "jks-gs-packages-bucket"
  acl    = "private"
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "jks-gs-packages-bucket"
  }
}

data "aws_security_group" "ssh_sg" {
  name = var.ssh_sg_name
}

data "aws_security_group" "games_sg" {
  name = var.games_sg_name
}

data "aws_security_group" "node_sg" {
  name = var.node_sg_name
}

module "ark_resources" {
  source = "./modules/Ark"

  server_region = "${var.server_region}"
  region_shortname = "${var.region_shortname}"
  availability_zone = "${var.availability_zone}"
  maps = var.ark_mapsets
  env = "${var.env}"
  packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
}

module "minecraft_resources" {
  source = "./modules/Minecraft"

  server_region = "${var.server_region}"
  region_shortname = "${var.region_shortname}"
  availability_zone = "${var.availability_zone}"
  maps = var.minecraft_maps
  env = "${var.env}"
  packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
}

module "valheim_resources" {
  source = "./modules/Valheim"

  server_region = "${var.server_region}"
  region_shortname = "${var.region_shortname}"
  availability_zone = "${var.availability_zone}"
  maps = var.valheim_maps
  env = "${var.env}"
  packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
}

# Note: Only one ark arn is used now, because each mapset is specific to a node.
# If we use multiple mapsets, then we'd describe them separately here as different variables.
module "nodes" {
  source = "./modules/nodes"

  server_region = "${var.server_region}"
  region_shortname = "${var.region_shortname}"
  env = "${var.env}"
  availability_zone = "${var.availability_zone}"
  subnet_id = var.subnet_id
  cluster_name = "${var.cluster_name}"
  ark_map_name = "all"
  packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
  packages_bucket_name = aws_s3_bucket.packages_bucket.id
  shared_package_version = var.shared_package_version
  ark_data_access_policy_arn = lookup(local.ark_data_access_policy_arns_map, local.ark_main_mapset)
  minecraft_data_access_policy_arns = module.minecraft_resources.data_access_policy_arns
  valheim_data_access_policy_arns = module.valheim_resources.data_access_policy_arns
  ark_data_volume_id = lookup(local.ark_data_volume_ids_map, local.ark_main_mapset)
  ark_resources_bucket_arn = lookup(local.ark_resources_bucket_arns_map, local.ark_main_mapset)
  ark_resources_bucket_name = lookup(local.ark_resources_bucket_names_map, local.ark_main_mapset)
  ark_backup_bucket_arn = lookup(local.ark_backup_bucket_arns_map, local.ark_main_mapset)
  ark_server_image_id = var.ark_server_image_id
  ark_backup_bucket_name = lookup(local.ark_backup_bucket_names_map, local.ark_main_mapset)
  ssh_sg_id = data.aws_security_group.ssh_sg.id
  games_sg_id = data.aws_security_group.games_sg.id
  node_sg_id = data.aws_security_group.node_sg.id
}