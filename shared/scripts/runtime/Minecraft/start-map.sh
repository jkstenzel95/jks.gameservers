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

java -Xmx1024M -Xms1024M -jar $SERVER_MOUNT_LOCATION/Minecraft/server.jar