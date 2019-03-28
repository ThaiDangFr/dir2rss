#!/bin/bash

export scriptpath=$(realpath -s $(dirname $0))
cd ${scriptpath}

PORT=4567
rackup -p ${PORT} -E production
