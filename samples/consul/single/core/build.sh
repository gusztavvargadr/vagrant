#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir -p ./tmp/

eval `bash ./env.sh`

consul acl bootstrap -format=json | tee ./tmp/acl.json

eval `bash ./env.sh`

consul acl set-agent-token agent $CONSUL_HTTP_TOKEN

consul members
