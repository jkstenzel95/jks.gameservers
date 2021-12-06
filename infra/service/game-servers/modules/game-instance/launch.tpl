#!/bin/bash
      OUTPUT=$(curl http://169.254.169.254/latest/meta-data/instance-id)
      aws ec2 attach-volume --volume-id ${volume_id} --device /dev/xvdf --instance-id $OUTPUT --region ${region}