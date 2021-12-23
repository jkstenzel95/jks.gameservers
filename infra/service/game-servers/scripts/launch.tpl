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
aws ec2 attach-volume --volume-id ${volume_id} --device "/dev/sdg" --instance-id $EC2_INSTANCE_ID --region ${region}

# https://serverfault.com/questions/975196/using-blkid-to-check-if-an-attached-ebs-volume-is-formatted
if ! (blkid --match-token TYPE=ext4 "/dev/sdg" || sudo mkfs.ext4 -m0 "/dev/sdg"); then
    echo "Could not format"
    while ! blkid --match-token TYPE=ext4 "/dev/sdg"; do echo "Waiting before checking if formatted yet"; sleep 15; done
    echo "Drive now formatted"
fi


sudo mkdir ${server_mount_location}
while ! (sudo mount /dev/sdg ${server_mount_location}); do echo "Mount not successful... retrying in 15 seconds"; sleep 15; done
sudo chmod ugo+wx ${server_mount_location}