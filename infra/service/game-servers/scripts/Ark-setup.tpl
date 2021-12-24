#!/bin/bash

sudo yum install nano wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
echo "fs.file-max=100000" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
echo -e "* soft nofile 1000000\n* hard nofile 1000000" | sudo tee -a /etc/security/limits.conf

pushd "${server_mount_location}"
if [[ ! -f "${init_flag}" ]]; then
    curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
    tar -zxf steamcmd.tar.gz
    rm steamcmd.tar.gz
    mkdir Ark
    sudo ./steamcmd.sh +force_install_dir "./Ark" +login anonymous +app_update 376030 validate +quit
fi

