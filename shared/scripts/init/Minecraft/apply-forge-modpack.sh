#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}/Minecraft"

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
modpack_zip=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .modpack_zip" | tr -d '"')
aws s3 cp "s3://${RESOURCE_BUCKET_NAME}/$modpack_zip" "./$modpack_zip"
unzip -o $modpack_zip
rm $modpack_zip

popd