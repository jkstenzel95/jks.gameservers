FROM amazonlinux:latest
ARG REPO_ROOT
ENV REPO_ROOT=$REPO_ROOT
COPY "${REPO_ROOT}/game-server/scripts/guest/init" /scripts
COPY "${REPO_ROOT}/shared/scripts/data" /game-info
RUN yum install python3 nano jq vim wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN sysctl -p /etc/sysctl.conf
RUN echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf
ENTRYPOINT [ "bash", "./scripts/init_map.sh" ]