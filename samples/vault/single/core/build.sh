#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir -p ./tmp/

eval `bash ./env.sh`
vault operator init -key-shares=1 -key-threshold=1 -format=json | tee ./tmp/init.json
vault status || true

jq -r .unseal_keys_b64[0] ./tmp/init.json | xargs vault operator unseal
vault status

jq -r .root_token ./tmp/init.json | vault login -
vault token lookup
