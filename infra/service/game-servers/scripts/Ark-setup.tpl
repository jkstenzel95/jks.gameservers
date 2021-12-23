#!/bin/bash

pushd "${server_mount_location}"
if [[ ! -f ./steamcmd.sh ]]; then
    curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
    tar -zxf steamcmd.tar.gz
    rm steamcmd.tar.gz
    mkdir Ark
    ./steamcmd.sh +login anonymous +force_install_dir "./Ark" +app_update 376030 validate +quit
fi