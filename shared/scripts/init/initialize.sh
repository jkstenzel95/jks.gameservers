#!/bin/bash

scripts_dir="${SHARED_DIR}/shared/scripts/init"
init_flag="${SERVER_MOUNT_LOCATION}/init_flag"

pushd $scripts_dir

. "wipe-if-requested.sh"

. "${GAME_NAME}/install-dependencies.sh"

if [[ ! -f "${init_flag}" ]]; then
    . "${GAME_NAME}/base-install.sh"
    touch $init_flag
else
    . "${GAME_NAME}/backup.sh"
fi

# check if backup needs to be downloaded again
export backup_version=$(. "get-backup-version.sh")
if [[ ($? -eq 0) && (! $backup_version == "") && (! $backup_version == "null") ]]
then
    # if so, download
    . "${GAME_NAME}/restore-backup.sh"
    # mark flag as not needing backup (empty string for the backup name)
    . "remove-backup-flag.sh"
fi

. "${GAME_NAME}/post-install.sh"

popd

[ -n "$USER" ] && sudo chown $USER -R $SERVER_MOUNT_LOCATION
sudo chmod -R 0777 $SERVER_MOUNT_LOCATION