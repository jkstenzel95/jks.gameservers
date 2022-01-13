#!/bin/bash
-e

scripts_dir="/gameservers-package/shared/scripts/init"
init_flag="${SERVER_MOUNT_LOCATION}/init_flag"

pushd $scripts_dir

. "${GAME_NAME}/install-dependencies.sh"

if [[ ! -f "${init_flag}" ]]; then
    . "${GAME_NAME}/base-install.sh"
    touch $init_flag
else
    . "${GAME_NAME}/backup.sh"
fi

# check if backup needs to be downloaded again
if ! . "check-no-restore-needed.sh"
then
    # if so, download
    . "${GAME_NAME}/restore-backup.sh"
    # mark flag as not needing backup (empty string for the backup name)
    . "remove-backup-flag.sh"
fi

. "${GAME_NAME}/post-install.sh"