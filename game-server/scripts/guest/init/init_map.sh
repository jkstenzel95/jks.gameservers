#!/bin/bash
-e

scripts_dir="~/scripts"

pushd $scripts_dir

lock_directory="${SERVER_MOUNT_LOCATION}/locks"
mkdir -p lock_directory
lock_type=$(awk -v key=$GAME_NAME '$1 ~ key {split($1,a,"=");print a[2]}' blah.ini)
if [lock_type == "GAME"]
then
    lock_file="${lock_directory}/${GAME_NAME}.lock"
elif
then
    lock_file="${lock_directory}/${GAME_NAME}_${MAP_NAME}.lock"
else
    >&2 echo "Lock file lookup does not recognize game ${GAME_NAME}"
    exit 1
fi

# Ensure only running once simultaneously
if mkdir $lock_file 2>/dev/null; then
    # check if set up.
    if . "${GAME_NAME}/check-map-downloaded.sh"
    then
        # if set up, back up the map
        . "${GAME_NAME}/backup.sh"
    fi

    # check if backup needs to be downloaded again
    if ! . "check-no-download-needed.sh"
    then
        # if so, download
        . "${GAME_NAME}/restore-backup.sh"
        # mark flag as not needing backup (empty string for the backup name)
        . "remove-backup-flag.sh"
    fi

    rm -r $lock_file
else
    # If another process is handling initialization, just wait on it
    echo "Another init process is handling the initialization for ${GAME_NAME}, ${MAP_NAME}. Lockfile: ${lock_file}"
    sleep 5
    while [ -d $lock_file ]
    do
        echo "Still awaiting initialization..."
        sleep 5
    done

    echo "Initialization complete for ${GAME_NAME}, ${MAP_NAME}"
fi

