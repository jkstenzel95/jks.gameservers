#!/bin/bash

while getopts u:a:f: flag
do
    case "${flag}" in
        s) steamdir=${OPTARG};;
    esac
done

pushd "${steamdir}"
curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
tar -zxf steamcmd.tar.gz
./steamcmd.sh