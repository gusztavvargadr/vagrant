#!/usr/bin/env sh

set -o errexit
set -o nounset

cp -R core/* config

chown -R consul:consul config

docker-entrypoint.sh agent
