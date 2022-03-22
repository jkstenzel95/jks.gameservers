#!/bin/bash

pushd "${SERVER_MOUNT_LOCATION}"
curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
tar -zxf steamcmd.tar.gz
rm steamcmd.tar.gz
mkdir -p Valheim
./steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir "./Valheim" +login anonymous +app_update 896660 validate +quit
popd