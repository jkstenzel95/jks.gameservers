#!/bin/bash

aws s3 cp "s3://${BACKUP_STORAGE_NAME}/${backup_version}.zip" Restore.zip

if [ -d "${SERVER_MOUNT_LOCATION}/Minecraft/world" ]; then
    mv "${SERVER_MOUNT_LOCATION}/Minecraft/world" "${SERVER_MOUNT_LOCATION}/Minecraft/world_old"
fi

mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')
replace_folder = "Minecraft/world"
if [[ is_modded == "true" ]]; then
    old_folder = "Minecraft"
else
fi

if unzip -o Restore.zip -d "${SERVER_MOUNT_LOCATION}/Minecraft" ; then
        if [ -d "${SERVER_MOUNT_LOCATION}/${replace_folder}_old" ]; then
            rm -R "${SERVER_MOUNT_LOCATION}/${replace_folder}_old"
        fi
    else
        if [ -d ${SERVER_MOUNT_LOCATION}/${replace_folder}_old ]; then
            mv "${SERVER_MOUNT_LOCATION}${replace_folder}_old" "${SERVER_MOUNT_LOCATION}/${replace_folder}"
        fi
        echo "Backup restore failed! Reverting to last."
    fi

rm Restore.zip