#!/usr/bin/env bash

set -o errexit
set -o nounset

docker exec badger consul members

docker run \
  -d \
  --name=fox \
  consul:1.11.4 agent -node=client-1 -join=172.17.0.2
read -p "Press Enter to continue..."

docker exec badger consul members
