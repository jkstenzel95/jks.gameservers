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
config_file_name="${SHARED_DIR}/shared/config/${ENVIRONMENT}.json"
mappings_file_name="${SHARED_DIR}/shared/data/ark_mappings.json"
MAP_DATA=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\")")
CONFIG_DATA=$(cat $config_file_name | jq ".games[] | select(.name == \"$GAME_NAME\")")
MAX_PLAYERS=$(echo $CONFIG_DATA | jq ".max_players")
MAP_CODE=$(echo $MAP_DATA | jq ".map_code" | tr -d '"')
MOD_LIST=$(echo $CONFIG_DATA | jq ".mods | @csv" | tr -d '"' | tr -d " ")
ADDITIONAL_SERVER_PARAMS=$(echo $MAP_DATA | jq ".additional_server_params" | tr -d '"')

SERVER_ADMIN_PASSWORD=$(cat /mnt/secrets-store/jks_gameservers_${ENVIRONMENT}_${REGION_SHORTNAME}_Ark-Server-Admin-Password | jq '."Ark-Server-Admin-Password"' | tr -d '"')

$SERVER_MOUNT_LOCATION/Ark/ShooterGame/Binaries/Linux/ShooterGameServer "${MAP_CODE}?listen?Multihome=0.0.0.0?SessionName=${SessionName}?MaxPlayers=${MAX_PLAYERS}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?Port=${SERVER_PORT_1}?ServerAdminPassword=${SERVER_ADMIN_PASSWORD}?AltSaveDirectoryName=${MAP_NAME}?OverrideOfficialDifficulty=5.0?GameModIds=${MOD_LIST}${ADDITIONAL_SERVER_PARAMS}" -server -log -NoTransferFromFiltering -exclusivejoin -clusterid="jks_cluster"

popd