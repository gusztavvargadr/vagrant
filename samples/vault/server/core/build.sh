#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir -p ./tmp/

export VAULT_ADDR=http://127.0.0.1:8200
vault status || true

vault operator init -key-shares=1 -key-threshold=1 -format=json | tee ./tmp/vault-operator-init.json
vault status || true

jq -r .unseal_keys_b64[0] ./tmp/vault-operator-init.json | xargs vault operator unseal
vault status

jq -r .root_token ./tmp/vault-operator-init.json | vault login -
vault token lookup
