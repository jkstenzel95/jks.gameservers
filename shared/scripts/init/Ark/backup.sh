#!/bin/bash
 
if ! pgrep -x "ShooterGameServer" > /dev/null
then
    python3 ./Ark/backup.py --shared-mount-location $SERVER_MOUNT_LOCATION --backup-storage-url $BACKUP_STORAGE_NAME
fi