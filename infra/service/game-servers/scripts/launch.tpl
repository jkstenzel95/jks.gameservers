#!/bin/bash

sudo yum update -y
sudo yum install unzip -y
sudo yum -y install wget

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
rm -r aws

die() { status=$1; shift; echo "FATAL: $*"; exit $status; }
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
aws ec2 attach-volume --volume-id ${volume_id} --device "/dev/sdg" --instance-id $EC2_INSTANCE_ID --region ${region}
while [ ! "$(ls /dev/sdg)" = "/dev/sdg" ]; do echo "Volume not yet attached... waiting 5s"; sleep 5; done
echo "Volume attached!"

echo "Ensuring formatted..."
# https://serverfault.com/questions/975196/using-blkid-to-check-if-an-attached-ebs-volume-is-formatted
while ! (blkid --match-token TYPE=ext4 "/dev/sdg" || sudo timeout 60 mkfs.ext4 -m0 "/dev/sdg"); do printf "\nLikely hung on prompt to format a formatted drive, retrying...\n"; done
echo "Ensured Formatting!"

sudo mkdir ${server_mount_location}
sudo chown ec2-user -R ${server_mount_location} 
sudo chmod -R 0777 ${server_mount_location}
echo "Attempting mount..."
while ! sudo mount /dev/sdg ${server_mount_location}; do echo "Mount not successful... retrying in 15 seconds"; sleep 15; done
echo "Mount complete!"