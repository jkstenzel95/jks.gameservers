#!/bin/bash

echo "{ \"Key\": {\"S\": \"backup_version\"}, \"KeyValue\": {\"S\": \"\"} }" > entry.json
aws dynamodb put-item --table-name "jks-gs-${ENVIRONMENT}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table" --item file://entry.json