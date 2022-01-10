#!/bin/bash

sudo yum install nano wget screen python3 glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
echo "fs.file-max=100000" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
echo -e "* soft nofile 1000000\n* hard nofile 1000000" | sudo tee -a /etc/security/limits.conf