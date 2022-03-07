FROM amazonlinux:latest

RUN yum install nano jq unzip vim wget screen python3 glibc.i686 libstdc++.i686 ncurses-libs.i686 sudo -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip
RUN rm -r aws
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf
ENTRYPOINT [ "bash", "/gameservers-package/shared/scripts/runtime/start-map.sh" ]