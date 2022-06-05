#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir -p ./tmp/

consul acl bootstrap -format=json | tee ./tmp/consul-acl-bootstrap.json
eval `bash ./env.sh`
consul info

consul acl set-agent-token agent $CONSUL_HTTP_TOKEN
consul info

consul members
