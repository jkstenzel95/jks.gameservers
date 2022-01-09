resource "aws_iam_policy" "data_access_policy" {
    name = "jks-gs-${var.env}-${var.region_shortname}-Ark-${var.map_name}-data_policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${var.resources_bucket_arn}",
                "${var.backup_bucket_arn}"
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
                "${var.resources_bucket_arn}/*",
                "${var.backup_bucket_arn}/*"
            ]
            }
        ]
    })
}

module "node_group" {
    source = "./../../node-group"

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    env = "${var.env}"
    availability_zone = "${var.availability_zone}"
    data_volume_id = "${var.data_volume_id}"
    game_name = "Ark"
    map_name = "${var.map_name}"
    instance_type = "${var.instance_type}"
    resources_bucket_name = "${var.resources_bucket_name}"
    base_security_group_id = "${var.base_security_group_id}"
    additional_security_group_id = "${var.additional_security_group_id}"
    server_image_id = "${var.server_image_id}"
    ssh_security_group = "${var.ssh_security_group}"
    game_policy_arn = "${aws_iam_policy.data_access_policy.arn}"
    cluster_name = "${var.cluster_name}"
    subnet_id = var.subnet_id
}