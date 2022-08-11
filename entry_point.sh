#! /bin/bash
if [ ! -d "/opt/Thinkbox/DeadlineRepository10" ]; then
    rsync -avi --progress --partail /root/Thinkbox/* /opt/Thinkbox/
fi

exec "$@"
