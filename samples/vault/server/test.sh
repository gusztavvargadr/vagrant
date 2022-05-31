#!/usr/bin/env bash

export VAULT_ADDR=http://127.0.0.1:8200

vault secrets enable -path=kv kv

vault kv put kv/hello target=world
vault kv get kv/hello

vault kv put kv/my-secret value="s3c(eT"
vault kv get kv/my-secret
vault kv delete kv/my-secret
vault kv list kv

vault secrets disable kv
