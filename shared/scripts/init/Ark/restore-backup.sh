#!/bin/bash

aws s3 cp "s3://${BACKUP_STORAGE_NAME}/${backup_version}.zip" Restore.zip
unzip -o Restore.zip -d "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Saved/"

rm Restore.zip