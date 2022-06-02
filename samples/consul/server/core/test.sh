#!/usr/bin/env bash

set -o errexit
set -o nounset

export CONSUL_HTTP_TOKEN=`jq -r .SecretID ./tmp/consul-acl-bootstrap.json`

consul kv put hello world
consul kv get hello
consul kv export

consul kv put config value
consul kv get config
consul kv export

consul kv delete hello
consul kv delete config
consul kv export
