#!/bin/bash

echo "Server wipe requested."
table_name="jks-gs-${ENVIRONMENT}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table"
echo "{ \"Key\": { \"S\": \"needs_wipe\" } }" > key.json
needs_wipe=$(aws dynamodb get-item --table-name $table_name --key "file://key.json" --projection-expression "KeyValue" | jq '."Item"."KeyValue"."BOOL"')
rm key.json

if [[ ( $(echo $needs_wipe | tr '[:upper:]' '[:lower:]') == "true") ||  ]]
then
    # if so, delete init flag and files
    if [ -f "${SERVER_MOUNT_LOCATION}/init_flag" ]; then
        echo "Init flag exists. Deleting."
        rm "${SERVER_MOUNT_LOCATION}/init_flag"
    fi

    if [ -d "${SERVER_MOUNT_LOCATION}/${GAME_NAME}" ]; then
        echo "Server folder exists. Deleting."
        rm -r "${SERVER_MOUNT_LOCATION}/${GAME_NAME}/*"
    fi
fi

echo "{ \"Key\": {\"S\": \"needs_wipe\"}, \"KeyValue\": {\"BOOL\": false} }" > entry.json
aws dynamodb put-item --table-name $table_name --item file://entry.json