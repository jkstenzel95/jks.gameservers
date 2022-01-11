module "shared_sg" {
    source = "./modules/security-group"

    env = "${var.env}"
}

resource "aws_s3_bucket" "packages_bucket" {
  bucket = "jks-gs-packages-bucket"
  acl    = "private"

  tags = {
    Name = "jks-gs-packages-bucket"
  }
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
    packages_bucket_arn = aws_s3_bucket.packages_bucket.arn
    packages_bucket_name = aws_s3_bucket.packages_bucket.id
    shared_package_version = var.shared_package_version
}