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

data "aws_security_group" "base_sg" {
  name = var.base_sg_name
}

data "aws_security_group" "node_sg" {
  name = var.node_sg_name
}

data "aws_security_group" "ark_sg" {
  name = var.ark_sg_name
}

module "ark_resources" {
    source = "./modules/Ark/ark-resources"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    availability_zone = "${var.availability_zone}"
    env = "${var.env}"
    server_image_id = "${var.ark_server_image_id}"
    instance_type = "${var.ark_instance_type}"
    ssh_sg_id = data.aws_security_group.ssh_sg.id
    base_sg_id = data.aws_security_group.base_sg.id
    node_sg_id = data.aws_security_group.node_sg.id
    ark_sg_id = data.aws_security_group.ark_sg.id
    cluster_name = "${var.cluster_name}"
    subnet_id = var.subnet_id
    packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
    packages_bucket_name = aws_s3_bucket.packages_bucket.id
    shared_package_version = var.shared_package_version
}