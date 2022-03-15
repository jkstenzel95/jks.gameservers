#!/bin/bash

map_init_flag="${SERVER_MOUNT_LOCATION}/Valheim_init_flag"

if [[ ! -f "${map_init_flag}" ]]; then
    exit 1
fi