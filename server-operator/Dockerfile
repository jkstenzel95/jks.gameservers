FROM mcr.microsoft.com/dotnet/sdk AS build
COPY ./src ./test /repo
RUN find "/repo/src" -type f -name "*.csproj" | while read -r x; do dotnet build "${x}" -c Release -p:BUILD_BUILDNUMBER="${BUILD_NUMBER}" -p:BUILD_SOURCEBRANCHNAME="${BUILD_BRANCH}" || exit 1; done
RUN find "/repo/test" -type f -name "*.csproj" | while read -r x; do dotnet test "${x}" -c Release -p:BUILD_BUILDNUMBER="${BUILD_NUMBER}" -p:BUILD_SOURCEBRANCHNAME="${BUILD_BRANCH}" -p:CollectCoverage=true -p:CoverletOutputFormat=opencover || exit 1; done
RUN find "/repo/src/service" -type f -name "*.csproj" | while read x; do dotnet publish -c Release --runtime linux-x64 -p:BUILD_BUILDNUMBER="${BUILD_NUMBER}" -p:BUILD_SOURCEBRANCHNAME="${BUILD_BRANCH}" "$x" || exit 1; done

FROM centos:latest
EXPOSE 443
RUN yum install nano wget screen glibc.i686 libstdc++.i686 ncurses-libs.i686 -y
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN sysctl -p /etc/sysctl.conf
RUN echo -e "* soft nofile 1000000\n* hard nofile 1000000" >> /etc/security/limits.conf
ENTRYPOINT [ "usr/bin/supervisord", "-c", "/app/supervisord.conf" ]