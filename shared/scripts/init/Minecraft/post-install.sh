#!/bin/bash

# TODO_MOD: This doesn't need to happen. In fact server.properties should be copied down.
pushd "${SERVER_MOUNT_LOCATION}"

if [ "${is_modded}" == "false" ]; then
    download_url=$(curl --no-progress-meter "$(curl --no-progress-meter https://launchermeta.mojang.com/mc/game/version_manifest.json | jq ".versions[0].url" | tr -d "\"")" | jq ".downloads.server.url" |  tr -d "\"")
    curl $download_url --output ./Minecraft/server.jar
fi
popd