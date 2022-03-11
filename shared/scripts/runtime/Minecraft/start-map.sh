prefix="" # Unused
postfix="" # Unused
while getopts e:o: flag
do
    case "${flag}" in
        e) prefix=${OPTARG};; # Unused
    esac
    case "${flag}" in
        o) postfix=${OPTARG};; # Unused
    esac
done

# TODO: the game server runtime image may need to reinstall dependencies. In fact, I think most will. Fix structuring.
. "${SHARED_DIR}/shared/scripts/init/Minecraft/install-dependencies.sh"
sudo java -Xmx1024M -Xms1024M -jar $SERVER_MOUNT_LOCATION/Minecraft/server.jar