#!/usr/bin/env bash

set -o errexit
set -o nounset

docker compose build consul-core
docker compose build
