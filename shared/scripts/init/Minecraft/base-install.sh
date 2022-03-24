#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts"

pushd $scripts_dir

mkdir -p "${SERVER_MOUNT_LOCATION}/Minecraft"

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')

if [ "${is_modded}" == "true" ]; then
    bash "${scripts_dir}/init/Minecraft/install-forge.sh"
    bash "${scripts_dir}/init/Minecraft/apply-forge-modpack.sh"
else
    # Vanilla server needs that jar to start
    pushd "${SERVER_MOUNT_LOCATION}"
    download_url=$(curl --no-progress-meter "$(curl --no-progress-meter https://launchermeta.mojang.com/mc/game/version_manifest.json | jq "[.versions[] | select(.type == \"release\")][0].url" | tr -d "\"")" | jq ".downloads.server.url" |  tr -d "\"")
    curl $download_url --output ./Minecraft/server.jar
    popd
fi

bash "${scripts_dir}/runtime/Minecraft/start-map.sh"

sed -i -e 's/eula=false/eula=true/g' "${SERVER_MOUNT_LOCATION}/Minecraft/eula.txt"

popd