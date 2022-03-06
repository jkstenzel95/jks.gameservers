#!/bin/bash

# Attach volume to node
die() { status=$1; shift; echo "FATAL: $*"; exit $status; }
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"

if [ $ATTACH_VOLUME == "true" ]; then
    VOLUME_ID=$(aws ec2 describe-volumes --filters "Name=tag:Name,Values=jks-gs-${ENVIRONMENT}-${GAME_NAME}-${MAP_SET}-data-volume" | jq ".Volumes[0].VolumeId" | tr -d "\"")
    until (aws ec2 attach-volume --volume-id $VOLUME_ID --device "/dev/sdg" --instance-id $EC2_INSTANCE_ID --region $REGION); do echo "Volume not available for attach... waiting 5s"; sleep 5; done
    while [ ! "$(ls /dev/sdg)" = "/dev/sdg" ]; do echo "Volume not yet attached... waiting 5s"; sleep 5; done
    echo "Volume attached!"

    # Format volume
    echo "Ensuring formatted..."
    # https://serverfault.com/questions/975196/using-blkid-to-check-if-an-attached-ebs-volume-is-formatted
    while ! (blkid --match-token TYPE=ext4 "/dev/sdg" || sudo timeout 60 mkfs.ext4 -m0 "/dev/sdg"); do printf "\nLikely hung on prompt to format a formatted drive, retrying...\n"; done
    echo "Ensured Formatting!"

    # Mount volume
    sudo mkdir ${SERVER_MOUNT_LOCATION}
    sudo chown ec2-user -R ${SERVER_MOUNT_LOCATION} 
    sudo chmod -R 0777 ${SERVER_MOUNT_LOCATION}
    echo "Attempting mount..."
    while ! sudo mount /dev/sdg ${SERVER_MOUNT_LOCATION}; do echo "Mount not successful... retrying in 15 seconds"; sleep 15; done
    echo "Mount complete!"
fi

# Attach public IP, works in conjunction with Kubernetes hostPort exposure of servers
PUBLIC_IP=$(echo $(aws ec2 describe-addresses --query 'Addresses[*].PublicIp' --filters Name=tag:Name,Values=jks-gs-dev-use2-ark-all) | grep -o '".*"' | sed 's/"//g')
ALLOCATION_ID=$(echo $(aws ec2 describe-addresses --query 'Addresses[*].AllocationId' --filters Name=tag:Name,Values=jks-gs-dev-use2-ark-all) | grep -o '".*"' | sed 's/"//g')
INTERFACE=$(aws ec2 describe-network-interfaces --filters Name=attachment.instance-id,Values=$EC2_INSTANCE_ID Name=addresses.primary,Values=true --query 'NetworkInterfaces[].{Id: NetworkInterfaceId, IP: Association.PublicIp}' | jq -c '.[] | select(.IP != null) | .Id' | tr -d '"')
aws ec2 associate-address --network-interface-id $INTERFACE --allocation-id $ALLOCATION_ID