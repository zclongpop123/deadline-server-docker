FROM almalinux:9 AS installer
  
RUN  sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^# baseurl=https://repo.almalinux.org|baseurl=https://mirrors.aliyun.com|g' \
         -i.bak \
         /etc/yum.repos.d/almalinux*.repo &&\
    dnf makecache &&\
    dnf install -y initscripts file bzip2 &&\
    mkdir /tmp/thinkboxsetup/

COPY mongodb-linux-x86_64-rhel90-6.0.16.tgz /tmp/thinkboxsetup/
COPY DeadlineRepository-10.*-linux-x64-installer.run /tmp/thinkboxsetup/

RUN /tmp/thinkboxsetup/DeadlineRepository-10.*-linux-x64-installer.run \
        --mode unattended \
        --dbtype MongoDB \
        --installmongodb true \
        --dbInstallationType prepackagedDB \
        --prepackagedDB /tmp/thinkboxsetup/mongodb-linux-x86_64-rhel90-6.0.16.tgz \
        --requireSSL true &&\
    rm -rf /opt/Thinkbox/DeadlineDatabase10/mongo/data/logs/* &&\
    cp /opt/Thinkbox/DeadlineDatabase10/certs/Deadline10Client.pfx /opt/Thinkbox/DeadlineRepository10/ &&\
    chmod +r /opt/Thinkbox/DeadlineRepository10/Deadline10Client.pfx

RUN sed -e 's|ssl:|tls:|g' \
        -e 's|requireSSL|requireTLS|g' \
        -e 's|PEMKeyFile|certificateKeyFile|g' \
        -e 's|  |    |g' \
        -i.bak \
    /opt/Thinkbox/DeadlineDatabase10/mongo/data/config.conf



FROM almalinux:9

RUN  sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^# baseurl=https://repo.almalinux.org|baseurl=https://mirrors.aliyun.com|g' \
         -i.bak \
         /etc/yum.repos.d/almalinux*.repo &&\
    dnf makecache &&\
    dnf install -y rsync compat-openssl11

COPY --from=installer /opt/Thinkbox /root/Thinkbox
COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV PATH=$PATH:/opt/Thinkbox/DeadlineDatabase10/mongo/application/bin

WORKDIR /opt/Thinkbox/DeadlineDatabase10/mongo

EXPOSE 27100

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mongod", "--config", "./data/config.conf"]
