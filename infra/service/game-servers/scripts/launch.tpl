#!/bin/bash
OUTPUT=$(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 attach-volume --volume-id ${volume_id} --device "/dev/sdg" --instance-id $OUTPUT --region ${region}
flock ~/format.lock
# https://serverfault.com/questions/975196/using-blkid-to-check-if-an-attached-ebs-volume-is-formatted
blkid --match-token TYPE=ext4 "/dev/sdg" || mkfs.ext4 -m0 "/dev/sdg"
sudo apt-get install supervisor