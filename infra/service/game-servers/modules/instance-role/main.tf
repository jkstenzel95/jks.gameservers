# the role that will be used in attaching the volume to a machine on startup
resource "aws_iam_role" "instance_iam_role" {
    name = "jks-gameservers-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-iam-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": [
                        "ec2.amazonaws.com"
                    ]
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "policy" {
    name = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-instance_policy"
    policy = jsonencode({
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
                    "arn:aws:ec2:*:*:volume/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:AllocateAddress",
                    "ec2:AssociateAddress",
                    "ec2:DescribeAddresses"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "ec2:DescribeVolumes",
                "Resource": "arn:aws:ec2:*:*:volume/*"
            },
            {
                "Sid": "DescribeQueryScanBooksTable",
                "Effect": "Allow",
                "Action": "dynamodb:*",
                "Resource": "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ec2-policy-attachment" {
    role = aws_iam_role.instance_iam_role.name
    policy_arn = aws_iam_policy.policy.arn
}