FROM amazonlinux:latest
EXPOSE 443
# Copy binaries under "${DATA_DISK_LOCATION}/server-operator
RUN yum install nano wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN sysctl -p /etc/sysctl.conf
RUN echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf
ENTRYPOINT [ "usr/bin/supervisord", "-c", "/app/supervisord.conf" ]

# Intent is to build a generic image with the server-operator build and use that in a kube yaml