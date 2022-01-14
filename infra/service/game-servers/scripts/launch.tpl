#!/bin/bash

-e

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

sudo mkdir ${SERVER_MOUNT_LOCATION}
sudo chown ec2-user -R ${SERVER_MOUNT_LOCATION} 
sudo chmod -R 0777 ${SERVER_MOUNT_LOCATION}
echo "Attempting mount..."
while ! sudo mount /dev/sdg ${SERVER_MOUNT_LOCATION}; do echo "Mount not successful... retrying in 15 seconds"; sleep 15; done
echo "Mount complete!"

export SERVER_MOUNT_LOCATION=${SERVER_MOUNT_LOCATION}
export GAME_NAME=${GAME_NAME}
export MAP_NAME=${MAP_NAME}
export ENV=${ENV}
export REGION_SHORTNAME=${REGION_SHORTNAME}
export BACKUP_STORAGE_NAME=${BACKUP_STORAGE_NAME}
export RESOURCE_BUCKET_NAME=${RESOURCE_BUCKET_NAME}

# Download scripts
if [ ! -d /gameservers-package ]
then
    sudo aws s3 cp "s3://${packages_bucket_name}/shared-packages/shared-package_${shared_package_version}.zip" /gameservers-package.zip
    sudo chmod -R 0777 /gameservers-package.zip
    mkdir /gameservers-package
    sudo chown ec2-user -R /gameservers-package
    sudo chmod -R 0777 /gameservers-package
    unzip -o gameservers-package.zip -d /gameservers-package
    rm /gameservers-package.zip
fi

# Run the entrypoint script

. /gameservers-package/shared/scripts/init/initialize.sh