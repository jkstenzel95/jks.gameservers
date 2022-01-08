FROM amazonlinux:latest
COPY /scripts /scripts
COPY /game-info /game-info
RUN yum install python3 nano jq vim wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN sysctl -p /etc/sysctl.conf
RUN echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf
ENTRYPOINT [ "bash", "./scripts/init_map.sh" ]