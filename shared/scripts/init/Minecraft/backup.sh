#!/bin/bash
 
 # TODO_MOD: This does not scale!!! We need per map stores, or at least backup naming that is map specific. Former preferred over latter.
python3 ./Minecraft/backup.py --shared-mount-location $SERVER_MOUNT_LOCATION --backup-storage-name $BACKUP_STORAGE_NAME