if [ $NEEDS_SETUP == "true" ]; then
    . "${SHARED_DIR}/shared/scripts/init/${GAME_NAME}/install-dependencies.sh"
fi
. "${SHARED_DIR}/shared/scripts/runtime/${GAME_NAME}/start-map.sh" -e "jks"
echo "Server failed to start! Sleeping to allow shell access for debugging."
sleep 1800