#!/bin/bash

prefix=""
postfix=""
while getopts m: flag
do
    case "${flag}" in
        m) map=${OPTARG};;
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
ServerAdminPassword="YourAdminPassword"
maxplayers="64"

screen -dmS ark ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?Multihome=0.0.0.0?SessionName=$?MaxPlayers=$?QueryPort=$?RCONPort=$?Port=$?ServerAdminPassword=$ -server -log