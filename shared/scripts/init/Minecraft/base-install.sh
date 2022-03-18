#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts"

pushd $scripts_dir

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')

bash "${scripts_dir}/runtime/Minecraft/start-map.sh"

sed -i -e 's/eula=false/eula=true/g' "${SERVER_MOUNT_LOCATION}/Minecraft/eula.txt"

popd