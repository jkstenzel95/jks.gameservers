#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}"

if [[ ! -f "${MAP_NAME}_init" ]]; then
    mkdir -p "./Ark/MapSaves"
    echo "If there is a backup available, for now it won't be loaded. WIP."
    # Load Backup!!!
fi