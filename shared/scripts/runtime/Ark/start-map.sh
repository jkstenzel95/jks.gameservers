#!/bin/bash

prefix=""
postfix=""
while getopts e:o: flag
do
    case "${flag}" in
        e) prefix=${OPTARG};;
    esac
    case "${flag}" in
        o) postfix=${OPTARG};;
    esac
done

pushd "${SERVER_MOUNT_LOCATION}/Ark"

if [[ "${prefix}" != "" ]]; then
    prefix="${prefix} :: "
fi

if [[ "${postfix}" != "" ]]; then
    postfix=" :: ${postfix}"
fi

SessionName="${prefix}${MAP_NAME}${postfix}"

SERVER_ADMIN_PASSWORD = aws secretsmanager get-secret-value --secret-id jks/gameservers/${ENVIRONMENT}/${REGION_SHORTNAME}/Ark-Server-Admin-Password --query SecretString --output text | jq '."Ark-Server-Admin-Password"' | tr -d '"'

$SERVER_MOUNT_LOCATION/Ark/ShooterGame/Binaries/Linux/ShooterGameServer "${MAP_CODE}?listen?Multihome=0.0.0.0?SessionName=${SessionName}?MaxPlayers=${MAX_PLAYERS}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?Port=${SERVER_PORT_1}?ServerAdminPassword=${SERVER_ADMIN_PASSWORD}?AltSaveDirectoryName=${MAP_NAME}?OverrideOfficialDifficulty=5.0?GameModIds=${MOD_LIST}${ADDITIONAL_SERVER_PARAMS}" -server -log -NoTransferFromFiltering -exclusivejoin -clusterid="jks_cluster"

popd