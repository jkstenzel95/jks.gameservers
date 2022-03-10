#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts/init"

pushd $scripts_dir

. "${GAME_NAME}/install-jdk.sh"

popd