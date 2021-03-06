#!/bin/bash

mkdir -p "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Saved/Config/LinuxServer"
mkdir -p "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Binaries/Linux"
mkdir -p "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Content/"

# TODO: This could be abstracted: File copies are a shared operation

# main server ini file
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/GameUserSettings.ini "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini"

# game ini file
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/Game.ini "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Saved/Config/LinuxServer/Game.ini"

# whitelist file
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/PlayersJoinNoCheckList.txt "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt"

# mods
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/Mods.zip Mods.zip
unzip -o Mods.zip -d "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Content/"
rm Mods.zip

pushd "${SERVER_MOUNT_LOCATION}"

./steamcmd.sh +force_install_dir "./Ark" +login anonymous +app_update 376030 validate +quit #TODO: Does the Ark server actually update?

popd