#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

bash ../core/clean.sh

docker-compose down --rmi all --volumes

docker builder prune -f
