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
export MAP_SET=${MAP_NAME}
export ENVIRONMENT=${ENVIRONMENT}
export REGION=${region}
export REGION_SHORTNAME=${REGION_SHORTNAME}
export BACKUP_STORAGE_NAME=${BACKUP_STORAGE_NAME}
export RESOURCE_BUCKET_NAME=${RESOURCE_BUCKET_NAME}
export SHARED_DIR=/gameservers-package
export DOMAIN=${DOMAIN}
export PUBLIC_IP_NAME=${PUBLIC_IP_NAME}
export ATTACH_IP="true"

echo "{ \"Key\": { \"S\": \"packages_test_version\" } }" > key.json
packages_test_version=$(aws dynamodb get-item --table-name "jks-gs-${ENVIRONMENT}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table" --key "file://key.json" --projection-expression "KeyValue" | jq '."Item"."KeyValue"."S"' | tr -d '"')
rm key.json
if [[ (! $packages_test_version == "") && (! $packages_test_version == "null") ]]; then
    shared_package_version=$packages_test_version
    echo "{ \"Key\": {\"S\": \"packages_test_version\"}, \"KeyValue\": {\"S\": \"\"} }" > entry.json
    aws dynamodb put-item --table-name "jks-gs-${ENVIRONMENT}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table" --item file://entry.json
    rm entry.json
else
    shared_package_version=${shared_package_version}
fi

# Download scripts
if [ ! -d $SHARED_DIR ]
then
    sudo aws s3 cp "s3://${packages_bucket_name}/shared-packages/shared-package_${shared_package_version}.zip" /gameservers-package.zip
    sudo chmod -R 0777 /gameservers-package.zip
    mkdir $SHARED_DIR
    sudo chown $USER -R $SHARED_DIR
    sudo chmod -R 0777 $SHARED_DIR
    unzip -o gameservers-package.zip -d $SHARED_DIR
    rm /gameservers-package.zip
fi

mkdir /etc/jks-gameserver
sudo chown $USER -R /etc/jks-gameserver
echo $PUBLIC_IP_NAME | tr '[:upper:]' '[:lower:]' > /etc/jks-gameserver/public-ip-name.txt
sudo chmod -R 0777 /etc/jks-gameserver

# If not setting up at launch, this will defer to the pod
if [ "${SETUP_AT_LAUNCH}" == "true" ]
then
    export ATTACH_VOLUME="true"
    . "$SHARED_DIR/shared/scripts/init/system-setup.sh"
fi

. /etc/eks/bootstrap.sh ${cluster_name}