#!/bin/bash

aws s3 cp "s3://${BACKUP_STORAGE_NAME}/${backup_version}.zip" Restore.zip

if [ -d "${SERVER_MOUNT_LOCATION}/Minecraft/world" ]; then
    mv "${SERVER_MOUNT_LOCATION}/Minecraft/world" "${SERVER_MOUNT_LOCATION}/Minecraft/world_old"
fi

if unzip -o Restore.zip -d "${SERVER_MOUNT_LOCATION}/Minecraft" ; then
    if [ -d "${SERVER_MOUNT_LOCATION}/Minecraft/world_old" ]; then
        rm -R "${SERVER_MOUNT_LOCATION}/Minecraft/world_old"
    fi
else
    if [ -d ${SERVER_MOUNT_LOCATION}/Minecraft/world_old ]; then
        mv "${SERVER_MOUNT_LOCATION}/Minecraft/world_old" "${SERVER_MOUNT_LOCATION}/Minecraft/world"
    fi
    echo "Backup restore failed! Reverting to last."
fi

rm Restore.zip