#!/bin/bash

mkdir -p "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Saved/Config/LinuxServer"
mkdir -p "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Binaries/Linux"

# main server ini file
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/GameUserSettings.ini "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini"
# whitelist file
aws s3 cp s3://${RESOURCE_BUCKET_NAME}/PlayersJoinNoCheckList.txt "${SERVER_MOUNT_LOCATION}/Ark/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt"