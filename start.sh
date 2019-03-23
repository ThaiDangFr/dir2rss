#!/bin/bash

export scriptpath=$(realpath -s $(dirname $0))
cd ${scriptpath}

PORT=4567
PIDFILE=${scriptpath}/dir2rss.pid

if [ ! -f ${PIDFILE} ];then
    rackup -p ${PORT} -E production -D -P ${PIDFILE}
    echo "dir2rss started on port ${PORT}"
else
    echo "${PIDFILE} already exists"
fi
