# the role that will be used in attaching the volume to a machine on startup
resource "aws_iam_role" "spot_launch_iam_role" {
    name = "jks-gameservers-${var.game_name}-${var.map_name}-iam-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:AttachVolume",
                    "ec2:DetachVolume"
                ],
                "Resource": [
                    "arn:aws:ec2:*:*:instance/*",
                    "arn:aws:ec2:*:*:volume/${var.data_volume_id}"
                ]
            },
            {
                "Effect": "Allow",
                "Action": "ec2:DescribeVolumes",
                "Resource": "arn:aws:ec2:*:*:volume/${var.data_volume_id}"
            }
        ]
    })
}

resource "aws_iam_instance_profile" "spot_launch_iam_profile" {
    name = "jks-gameservers-${var.game_name}-${var.map_name}-iam-profile"
    role = aws_iam_role.spot_launch_iam_role.name
}