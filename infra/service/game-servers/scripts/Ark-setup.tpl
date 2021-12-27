#!/bin/bash

sudo yum install nano wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
echo "fs.file-max=100000" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
echo -e "* soft nofile 1000000\n* hard nofile 1000000" | sudo tee -a /etc/security/limits.conf

# TODO: Move server init code to new script
pushd "${server_mount_location}"
if [[ ! -f "${init_flag}" ]]; then
    curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
    tar -zxf steamcmd.tar.gz
    rm steamcmd.tar.gz
    mkdir Ark
    sudo ./steamcmd.sh +force_install_dir "./Ark" +login anonymous +app_update 376030 validate +quit
    aws s3 cp s3://${resource_bucket_name}/Mods.zip Mods.zip
    unzip -o Mods.zip -d "${server_mount_location}/Ark/ShooterGame/Content/"
    mkdir Ark/MapSaves
    # Load backup configs that aren't map specific.
fi

# Download scripts (Publish these to game resources s3)
# Pull latest config