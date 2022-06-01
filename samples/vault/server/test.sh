#!/usr/bin/env bash

export VAULT_ADDR=http://127.0.0.1:8200

vault secrets enable -path=kv kv

vault kv put kv/hello target=world
vault kv get kv/hello
vault kv list kv

vault kv put kv/secret value="s3c(eT"
vault kv get kv/secret
vault kv list kv

vault kv delete kv/hello
vault kv delete kv/secret
vault kv list kv

vault secrets disable kv
