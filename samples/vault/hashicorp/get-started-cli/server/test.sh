#!/usr/bin/env bash

set -o errexit
set -o nounset

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

vault status
read -p "Press Enter to continue..."

vault kv put secret/hello foo=world
vault kv put secret/hello foo=world excited=yes

vault kv get secret/hello
vault kv get -field=excited secret/hello
vault kv get -format=json secret/hello | jq -r .data.data.excited

vault kv delete secret/hello
vault kv get secret/hello
vault kv undelete -versions=2 secret/hello
vault kv get secret/hello

vault kv metadata delete secret/hello
vault kv list secret
read -p "Press Enter to continue..."

vault secrets enable -path=kv kv

vault kv put kv/hello target=world
vault kv get kv/hello

vault kv put kv/my-secret value="s3c(eT"
vault kv get kv/my-secret
vault kv delete kv/my-secret
vault kv list kv

vault secrets disable kv
read -p "Press Enter to continue..."
