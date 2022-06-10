#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

docker-compose build

docker-compose up -d
sleep 5s

bash ../core/build.sh
