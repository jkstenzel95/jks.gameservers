#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}"

#TODO: This json parse happens all the time, reduce to a single export call
mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')

if [ "${is_modded}" == "false" ]; then
    download_url=$(curl --no-progress-meter "$(curl --no-progress-meter https://launchermeta.mojang.com/mc/game/version_manifest.json | jq ".versions[0].url" | tr -d "\"")" | jq ".downloads.server.url" |  tr -d "\"")
    curl $download_url --output ./Minecraft/server.jar
fi
popd