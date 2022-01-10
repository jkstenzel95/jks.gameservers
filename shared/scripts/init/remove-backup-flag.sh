#!/bin/bash

# TODO
aws dynamodb put-item --table-name "" --item "{ 'Key': {'S': '${GAME_NAME}_${MAP_NAME}_backup_version'}, 'Value': {'S': ''} }"