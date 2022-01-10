#!/bin/bash

# TODO
aws dynamodb get-item --table-name "jks-gs-${ENV}-${REGION_SHORTNAME}-${GAME_NAME}-${MAP_NAME}-kv_table" --key "${GAME_NAME}_${MAP_NAME}_backup_version"