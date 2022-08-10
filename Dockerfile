FROM rockylinux:8.6 AS installer
  
MAINTAINER zangchanglong

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.nju.edu.cn/rocky|g' \
    -i.bak \
    /etc/yum.repos.d/Rocky-*.repo &&\
    dnf makecache &&\
    mkdir /tmp/thinkboxsetup/


COPY ./mongodb-linux-x86_64-rhel80-4.2.12.tgz /tmp/thinkboxsetup/
COPY ./DeadlineRepository-10.*-linux-x64-installer.run /tmp/thinkboxsetup/


RUN dnf install -y file bzip2 &&\
    /tmp/thinkboxsetup/DeadlineRepository-10.*-linux-x64-installer.run \
        --mode unattended \
        --dbtype MongoDB \
        --installmongodb true \
        --dbInstallationType prepackagedDB \
        --prepackagedDB /tmp/thinkboxsetup/mongodb-linux-x86_64-rhel80-4.2.12.tgz \
        --requireSSL true


FROM rockylinux:8.6

COPY --from=installer /opt/Thinkbox /opt/Thinkbox

EXPOSE 27100

WORKDIR /opt/Thinkbox/DeadlineDatabase10/mongo

ENTRYPOINT ["./application/bin/mongod", "--config", "./data/config.conf"]
