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
    source = "./modules/Ark/ark-resources"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.availability_zone}"
    env = "${var.env}"
    packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
}

module "minecraft_resources" {
    source = "./modules/Minecraft/minecraft-resources"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.availability_zone}"
    env = "${var.env}"
    packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
}

module "valheim_resources" {
    source = "./modules/Minecraft/valheim-resources"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.availability_zone}"
    env = "${var.env}"
    packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
}

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
  ark_data_access_policy_arn = module.minecraft_resources.data_access_policy_arn
  minecraft_data_access_policy_arn = module.minecraft_resources.data_access_policy_arn
  ark_data_volume_id = module.ark_resources.shared_data_volume_id
  ark_resources_bucket_arn = module.ark_resources.resources_bucket_arn
  ark_resources_bucket_name = "${module.ark_resources.resources_bucket_name}"
  ark_backup_bucket_arn = "${module.ark_resources.backup_bucket_arn}"
  ark_backup_bucket_name = "${module.ark_resources.backup_bucket_name}"
  ark_server_image_id = var.ark_server_image_id
  ssh_sg_id = data.aws_security_group.ssh_sg.id
  games_sg_id = data.aws_security_group.games_sg.id
  node_sg_id = data.aws_security_group.node_sg.id
}