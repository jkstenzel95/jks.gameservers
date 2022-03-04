#!/bin/bash

aws s3 cp "s3://${BACKUP_STORAGE_NAME}/${backup_version}.zip" Restore.zip
mv "${SERVER_MOUNT_LOCATION}/Minecraft" "${SERVER_MOUNT_LOCATION}/Minecraft_old"
if unzip -o Restore.zip -d "${SERVER_MOUNT_LOCATION}/Minecraft" ; then
    rm "${SERVER_MOUNT_LOCATION}/Minecraft_old"
else
    mv "${SERVER_MOUNT_LOCATION}/Minecraft_old" "${SERVER_MOUNT_LOCATION}/Minecraft"
    echo "Backup restore failed! Reverting to last."
fi

rm Restore.zip