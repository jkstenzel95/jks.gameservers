#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}"
mkdir Minecraft
download_url=$(curl --no-progress-meter "$(curl --no-progress-meter https://launchermeta.mojang.com/mc/game/version_manifest.json | jq ".versions[0].url" | tr -d "\"")" | jq ".downloads.server.url" |  tr -d "\"")
curl $download_url --output ./Minecraft/server.jar
popd