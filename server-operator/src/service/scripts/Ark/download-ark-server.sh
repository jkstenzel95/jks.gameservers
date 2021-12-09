#!/bin/bash

while getopts u:a:f: flag
do
    case "${flag}" in
        d) datadirectory=${OPTARG};;
        m) map=${OPTARG};;
        s) serverlistfile=${OPTARG};;
    esac
done

gamefolder="${datadirectory}/servers/Ark"
clusterid="${jksark}"

pushd "${gamefolder}"

# https://www.servermania.com/kb/articles/how-to-install-ark-survival-evolved-server-on-linux/

yum update -y

if ! grep "^${game}/" "${serverlistfile}"; then
    echo "Ark server not set up, proceeding with setup."

    # Run these commands to open ports in the firewall:
    firewall-cmd --permanent --zone=public --add-port=27015/udp
    firewall-cmd --permanent --zone=public --add-port=7777/udp
    firewall-cmd --permanent --zone=public --add-port=32330/udp

    # Run the following command to install the libraries required for SteamCMD:
    yum install nano wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y

    # SteamCMD requires a few changes to sysctl.conf to run properly. This command will update the max files open:
    echo "fs.file-max=100000" >> /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf

    # We'll input information into our limits.conf file with this command:
    echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf

    steamdir="${datadirectory}/installations/steam"
    if ! -d "${steamdir}"
        echo "SteamCMD not installed at ${steamdir}, installing."
        mkdir "${steamdir}"
        . "${SCRIPT_DIR}/install-steam.sh""
    fi    
fi