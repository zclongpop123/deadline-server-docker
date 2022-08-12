#! /bin/bash
if [ ! -d "/opt/Thinkbox/DeadlineRepository10" ]; then
    rsync -avi --ignore-existing --progress --partial /root/Thinkbox/* /opt/Thinkbox/
fi

exec "$@"
