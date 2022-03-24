prefix="" # Unused
postfix="" # Unused
initial_setup="false"
while getopts e:o:i: flag
do
    case "${flag}" in
        e) prefix=${OPTARG};; # Unused
    esac
    case "${flag}" in
        o) postfix=${OPTARG};; # Unused
    esac
    case "${flag}" in
        i) initial_setup=${OPTARG};; # Unused
    esac
done

pushd $SERVER_MOUNT_LOCATION/Minecraft
mappings_file_name="${SHARED_DIR}/shared/data/minecraft_mappings.json"
java_args=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .java_args" | tr -d '"')
is_modded=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .is_modded" | tr -d '"')
server_jar="server.jar"
footer=""

if [ -f /etc/profile.d/jdk.sh ]; then
    source /etc/profile.d/jdk.sh
fi

if [ "${is_modded}" == "true" ]; then
    forge_version=$(cat $mappings_file_name | jq ".maps[] | select(.name == \"$MAP_NAME\") | .forge_version" | tr -d '"')
    if [[ -f "${forge_version}-universal.jar" ]]; then
        server_jar="${forge_version}-universal.jar"
    else
        server_jar="${forge_version}.jar"
    fi
    footer="nogui"
fi

java $java_args -jar $server_jar --port $SERVER_PORT $footer

popd