#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts/init"

pushd $scripts_dir

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')
if [ "${is_modded}" == "true" ]; then
    bash "${scripts_dir}/init/Minecraft/install-forge.sh"
    bash "${scripts_dir}/init/Minecraft/apply-forge-modpack.sh"
else
    jdk_version=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .jdk_version" | tr -d '"')
    . "${GAME_NAME}/${MAP_NAME}/install-jdk-${jdk_version}.sh"
fi

popd