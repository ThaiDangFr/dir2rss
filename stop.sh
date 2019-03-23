#!/bin/bash

export scriptpath=$(dirname $0)
cd ${scriptpath}

PIDFILE=${scriptpath}/dir2rss.pid

if [ -f ${PIDFILE} ];then
    kill -9 $(cat ${PIDFILE}) && rm -f ${PIDFILE}
    if [ $? -eq 0 ];then
	echo "dir2rss stopped"
    fi
else
    echo "dir2rss not running"
fi
