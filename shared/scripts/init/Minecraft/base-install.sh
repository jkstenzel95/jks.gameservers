#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts"

pushd $scripts_dir

mkdir -p "${SERVER_MOUNT_LOCATION}/Minecraft"

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')
eula_hangs=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .eula_hangs" | tr -d '"')

if [ "${is_modded}" == "true" ]; then
    bash "${scripts_dir}/init/Minecraft/apply-forge-modpack.sh"
    bash "${scripts_dir}/init/Minecraft/install-forge.sh"
else
    # Vanilla server needs that jar to start
    pushd "${SERVER_MOUNT_LOCATION}"
    download_url=$(curl --no-progress-meter "$(curl --no-progress-meter https://launchermeta.mojang.com/mc/game/version_manifest.json | jq "[.versions[] | select(.type == \"release\")][0].url" | tr -d "\"")" | jq ".downloads.server.url" |  tr -d "\"")
    curl $download_url --output ./Minecraft/server.jar
    popd
fi

if [ "${eula_hangs}" == "true" ]; then
    echo "Since the server will hang awaiting a EULA agreement, the server will be killed once that prompt is issued."
    awaiting_eula_text=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .awaiting_eula_text" | tr -d '"')
    bash "${scripts_dir}/init/run-and-kill-after-phrase.sh" -c "bash ${scripts_dir}/runtime/Minecraft/start-map.sh" -r "$awaiting_eula_text"
else
    bash "${scripts_dir}/runtime/Minecraft/start-map.sh"
fi

sed -i -e 's/eula=false/eula=true/g' "${SERVER_MOUNT_LOCATION}/Minecraft/eula.txt"

popd