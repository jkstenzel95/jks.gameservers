#!/bin/bash

while getopts d:g:m: flag
do
    case "${flag}" in
        d) datadirectory=${OPTARG};;
        g) game=${OPTARG};;
        m) map=${OPTARG};;
    esac
done

serverlistfile="created_servers.txt"

# 1.) lock serverlist file
flock "${datadirectory}/${serverlistfile}"
# 2.) check marker or condition for map being created
if grep "^${game}/${map}$" "${serverlistfile}"; then
    echo "${game}/${map} already exists. Exiting."
    exit 1
fi

# 3.a) no:
# 3.a.1) download and run appropriate commands to start server (where should installation happen? Depends on if storage is transient)
serversfile="${datadirectory}/servers"
game_lc=$(echo "${game}" | tr "[:upper:]" "[:lower:]")
. "${SCRIPT_DIR}/${game}/download-${game_lc}-server.sh" -d "$datadirectory" -m "${map}" -s  "${serversfile}"

# 3.a.2) set any "downloaded" markers
# 4.) exit appropriately
exit