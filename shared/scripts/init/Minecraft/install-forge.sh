#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}/Minecraft"

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
forge_version=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .forge_version" | tr -d '"')

if [ -f /etc/profile.d/jdk.sh ]; then
    source /etc/profile.d/jdk.sh
fi

if [ ! -f "${forge_version}-universal.jar" ]; then
    echo "Universal jar already exists, skipping installer download"
    aws s3 cp s3://${RESOURCE_BUCKET_NAME}/${forge_version}-installer.jar "./${forge_version}-installer.jar"
    java -jar "${forge_version}-installer.jar" --installServer
    rm ${forge_version}-installer.jar ${forge_version}-installer.jar.log
fi

popd