#!/bin/bash
sudo yum update -y
sudo yum install unzip -y
sudo yum -y install wget

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
rm -r aws

die() { status=$1; shift; echo "FATAL: $*"; exit $status; }
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
aws ec2 attach-volume --volume-id ${volume_id} --device "/dev/sdg" --instance-id $OUTPUT --region ${region}
flock ~/format.lock
# https://serverfault.com/questions/975196/using-blkid-to-check-if-an-attached-ebs-volume-is-formatted
blkid --match-token TYPE=ext4 "/dev/sdg" || mkfs.ext4 -m0 "/dev/sdg"
sudo apt-get install supervisor