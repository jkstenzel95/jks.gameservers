#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}/Minecraft"

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
forge_version=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .forge_version" | tr -d '"')
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/${forge_version}-installer.jar "./${forge_version}-installer.jar"
java -jar "${forge_version}-installer.jar" --installServer
rm ${forge_version}-installer.jar ${forge_version}-installer.jar.log

popd