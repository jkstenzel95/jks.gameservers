#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}"
curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
tar -zxf steamcmd.tar.gz
rm steamcmd.tar.gz
mkdir Ark
./steamcmd.sh +force_install_dir "./Ark" +login anonymous +app_update 376030 validate +quit