#!/bin/bash

while getopts s: flag
do
    case "${flag}" in
        s) steamdir=${OPTARG};;
    esac
done

pushd "${steamdir}"
curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz > steamcmd.tar.gz
tar -zxf steamcmd.tar.gz
./steamcmd.sh