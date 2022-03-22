#!/bin/bash

version=0
while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

if [ $version == 8 ]; then
    sudo yum update -y
    sudo yum install java-1.8.0-openjdk -y
    exit 0
elif [ $version == 17 ]; then
    sudo dnf -y install curl wget
    wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
    tar xvf openjdk-17_linux-x64_bin.tar.gz
    sudo mv jdk-17 /opt/

    sudo tee /etc/profile.d/jdk.sh <<EOF
    export JAVA_HOME=/opt/jdk-17
    export PATH=\$PATH:\$JAVA_HOME/bin
EOF
    exit 0
else
    echo "ERROR: Java version $version does not have installation logic."
    exit 1
fi