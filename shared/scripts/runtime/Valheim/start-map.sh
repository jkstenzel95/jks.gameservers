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

pushd "${SERVER_MOUNT_LOCATION}/Valheim"

if [[ "${prefix}" != "" ]]; then
    prefix="${prefix} :: "
fi

if [[ "${postfix}" != "" ]]; then
    postfix=" :: ${postfix}"
fi

SessionName="${prefix}${MAP_NAME}${postfix}"
config_file_name="${SHARED_DIR}/shared/config/${ENVIRONMENT}.json"
mappings_file_name="${SHARED_DIR}/shared/data/valheim_mappings.json"
MAP_DATA=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\")")
CONFIG_DATA=$(cat $config_file_name | jq ".games[] | select(.name == \"$GAME_NAME\")")

echo "LD_LIBRARY_PATH preswap: $LD_LIBRARY_PATH"
export templdpath=$LD_LIBRARY_PATH
echo "templdpath preswap: $LD_LIBRARY_PATH"
export LD_LIBRARY_PATH=$SERVER_MOUNT_LOCATION/Valheim/linux64:$LD_LIBRARY_PATH  
echo "LD_LIBRARY_PATH postswap: $LD_LIBRARY_PATH"
export SteamAppID=892970

SERVER_PASSWORD=$(cat /mnt/secrets-store/jks_gameservers_${ENVIRONMENT}_${REGION_SHORTNAME}_Valheim-Server-Password | jq '."Valheim-Server-Password"' | tr -d '"')

$SERVER_MOUNT_LOCATION/Valheim/valheim_server.x86_64 -name "<servername>" -port $SERVER_PORT -nographics -batchmode -world "${MAP_NAME}" -password "${SERVER_PASSWORD}" -public 1

export LD_LIBRARY_PATH=$templdpath

popd