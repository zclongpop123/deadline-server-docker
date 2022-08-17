#!/bin/bash
export PATH=$PATH:/opt/Thinkbox/DeadlineDatabase10/mongo/application/bin
cd /opt/Thinkbox/DeadlineDatabase10/certs
mongodump --port=27100 --ssl --sslCAFile ./ca.crt --sslPEMKeyFile ./mongo_client.pem --authenticationMechanism=MONGODB-X509 --sslAllowInvalidHostnames -d deadline10db -o /opt/backup/`date -I`
