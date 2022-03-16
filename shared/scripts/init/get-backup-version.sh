#!/bin/bash

# TODO Who says we can't use the kv for packages version?
echo "{ \"Key\": { \"S\": \"${GAME_NAME}_${MAP_NAME}_backup_version\" } }" > key.json
aws dynamodb get-item --table-name "jks-gs-${ENVIRONMENT}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table" --key "file://key.json" --projection-expression "KeyValue" | jq '."Item"."KeyValue"."S"' | tr -d '"'
rm key.json