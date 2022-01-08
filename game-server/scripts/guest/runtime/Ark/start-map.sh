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

pushd "${SERVER_MOUNT_LOCATION}/Ark"

if "${prefix}" -ne ""; then
    prefix="${prefix} :: "
fi

if "${postfix}" -ne ""; then
    prefix=" :: ${postfix}"
fi

SessionName="${prefix}${map}${postfix}"

SERVER_ADMIN_PASSWORD = aws secretsmanager get-secret-value --secret-id jks/gameservers/${ENVIRONMENT}/${REGION_SHORTNAME}/Ark-Server-Admin-Password --query SecretString --output text | jq '."Ark-Server-Admin-Password"'

ShooterGame/Binaries/Linux/ShooterGameServer "${MAP_CODE}?listen?Multihome=0.0.0.0?SessionName=${SessionName}?MaxPlayers=${MAX_PLAYERS}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?Port=${PORT}?ServerAdminPassword=${SERVER_ADMIN_PASSWORD}?AltSaveDirectoryName=${MAP_NAME}?OverrideOfficialDifficulty=5.0?GameModIds=${MOD_LIST}" -server -log -NoTransferFromFiltering -exclusivejoin -clusterid="${CLUSTER_ID}"
