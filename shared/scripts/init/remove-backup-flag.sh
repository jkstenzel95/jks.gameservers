#!/bin/bash

echo "{ \"Key\": {\"S\": \"${GAME_NAME}_${MAP_NAME}_backup_version\"}, \"KeyValue\": {\"S\": \"\"} }" > entry.json
aws dynamodb put-item --table-name "jks-gs-${ENV}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table" --item file://entry.json