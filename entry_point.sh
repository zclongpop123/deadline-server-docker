#! /bin/bash
if [ ! -d "/opt/Thinkbox/DeadlineRepository10" ]; then
    rsync -av /root/Thinkbox/* /opt/Thinkbox/
fi
