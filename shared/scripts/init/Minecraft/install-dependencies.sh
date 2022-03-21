#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts/init"

pushd $scripts_dir

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')
jdk_version=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .jdk_version" | tr -d '"')

bash "${GAME_NAME}/${MAP_NAME}/install-jdk.sh" -v $jdk_version

popd