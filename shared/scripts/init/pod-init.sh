#!/bin/bash

# If not set up at launch, the pod needs to perform this setup
if [ "${NEEDS_SETUP}" == "true" ]
then
    export ATTACH_VOLUME="false"
    . "/$SHARED_DIR/shared/scripts/init/system-setup.sh"
fi