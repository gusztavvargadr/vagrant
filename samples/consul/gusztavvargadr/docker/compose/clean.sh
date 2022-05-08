#!/usr/bin/env bash

set -o errexit
set -o nounset

docker-compose down --rmi all --volumes
