module "shared_data_volume" {
    source = "./../minecraft-volume"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    map_name = "${var.map_name}"
    env = "${var.env}"
    availability_zone = "${var.availability_zone}"
}

module "resources_bucket" {
    source = "./../../s3-bucket"

    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Minecraft"
    purpose = "gameresources"
}

module "backup_bucket" {
    source = "./../../s3-bucket"

    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Minecraft"
    map_name = "${var.map_name}"
    purpose = "backup"
}

module "kv_store" {
    source = "./../../game-kv-store"

    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    game_name = "Minecraft"
    map_name = "${var.map_name}"
}

resource "aws_iam_policy" "data_access_policy" {
    name = "jks-gs-${var.env}-${var.region_shortname}-Minecraft-${var.map_name}-data_policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:ListBucket"
                ],
                "Resource": [
                    "${module.resources_bucket.arn}",
                    "${module.backup_bucket.arn}",
                    "${var.packages_bucket_arn}"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:DeleteObject",
                    "s3:PutObjectAcl"
                ],
                "Resource": [
                    "${module.resources_bucket.arn}/*",
                    "${module.backup_bucket.arn}/*",
                    "${var.packages_bucket_arn}/*"
                ]
            }
        ]
    })
}