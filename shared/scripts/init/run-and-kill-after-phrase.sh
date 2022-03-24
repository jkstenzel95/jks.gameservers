#!/bin/bash

command=""
regex=""
while getopts c:r: flag
do
    case "${flag}" in
        c) command=${OPTARG};;
        r) regex=${OPTARG};;
    esac
done

log="init.log"

$command > "$log" 2>&1 &
pid=$!

while sleep 60
do
    if fgrep --quiet "$match" "$log"
    then
        kill $pid
        rm $log
        exit 0
    else
        echo "Still awaiting a match in the form of $match"
    fi
done