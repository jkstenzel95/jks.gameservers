#!/bin/bash

set -o xtrace

sudo yum update -y
sudo yum install unzip -y
sudo yum -y install wget jq

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
rm -r aws

export SERVER_MOUNT_LOCATION=${SERVER_MOUNT_LOCATION}
export GAME_NAME=${GAME_NAME}
export MAP_NAME=${MAP_NAME}
export ENVIRONMENT=${ENVIRONMENT}
export REGION_SHORTNAME=${REGION_SHORTNAME}
export BACKUP_STORAGE_NAME=${BACKUP_STORAGE_NAME}
export RESOURCE_BUCKET_NAME=${RESOURCE_BUCKET_NAME}
export SHARED_DIR=/gameservers-package

# Download scripts
if [ ! -d $SHARED_DIR ]
then
    sudo aws s3 cp "s3://${packages_bucket_name}/shared-packages/shared-package_${shared_package_version}.zip" /gameservers-package.zip
    sudo chmod -R 0777 /gameservers-package.zip
    mkdir $SHARED_DIR
    sudo chown ec2-user -R $SHARED_DIR
    sudo chmod -R 0777 $SHARED_DIR
    unzip -o gameservers-package.zip -d $SHARED_DIR
    rm /gameservers-package.zip
fi

# If not setting up at launch, this will defer to the pod
if [ "${SETUP_AT_LAUNCH}" == "true" ]
then
    . "/$SHARED_DIR/shared/scripts/init/system-setup.sh"
fi

. /etc/eks/bootstrap.sh ${cluster_name}