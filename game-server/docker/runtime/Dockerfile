FROM amazonlinux:latest

RUN yum install nano jq unzip vim wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip
RUN rm -r aws
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf
ENTRYPOINT [ "bash", "/scripts/start-map.sh" ]

# Intent is to build a generic image with the server-operator build and use that in a kube yaml