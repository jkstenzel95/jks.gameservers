#!/bin/bash

# Volume and networking setup
. /${SHARED_DIR}/shared/scripts/init/node-setup.sh

# Set up dependencies and server files if currently setting up for a game
if [ $GAME_NAME != "" ]; then
    . /${SHARED_DIR}/shared/scripts/init/initialize.sh
fi