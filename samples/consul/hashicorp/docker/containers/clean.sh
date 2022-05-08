#!/usr/bin/env bash

set -o errexit
set -o nounset

docker exec fox consul leave

docker exec badger consul leave

docker container prune -f
docker volume prune -f
