#!/bin/bash

prefix=""
postfix=""
while getopts u:a:f: flag
do
    case "${flag}" in
        m) map=${OPTARG};;
    esac
    case "${flag}" in
        e) prefix=${OPTARG};;
    esac
    case "${flag}" in
        o) postfix=${OPTARG};;
    esac
done

if "${prefix}" -ne ""; then
    prefix="${prefix} :: "
fi

if "${postfix}" -ne ""; then
    prefix=" :: ${postfix}"
fi

SessionName="${prefix}${map}${postfix}"
port="7777"
queryport="27015"
rconport="32330"
# Store this in a kv!
ServerAdminPassword="${SERVER_ADMIN_PASSWORD}"
maxplayers="16"

ShooterGame/Binaries/Linux/ShooterGameServer "${MAP_NAME}?listen?Multihome=0.0.0.0?SessionName=${SessionName}?MaxPlayers=${maxplayers}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?Port=${PORT}?ServerAdminPassword=${SERVER_ADMIN_PASSWORD}" -server -log