curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
tar -zxf steamcmd.tar.gz
./steamcmd.sh +login anonymous +force_install_dir "${GAME_SERVER_LOCATION}" +app_update 376030 validate +quit