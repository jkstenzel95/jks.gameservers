#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts"

pushd $scripts_dir

mkdir "${SERVER_MOUNT_LOCATION}/Minecraft"

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')

if [ "${is_modded}" == "true" ]; then
    bash "${scripts_dir}/init/Minecraft/install-forge.sh"
    bash "${scripts_dir}/init/Minecraft/apply-forge-modpack.sh"
else

bash "${scripts_dir}/runtime/Minecraft/start-map.sh"

sed -i -e 's/eula=false/eula=true/g' "${SERVER_MOUNT_LOCATION}/Minecraft/eula.txt"

popd