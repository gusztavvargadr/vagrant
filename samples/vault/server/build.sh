#!/usr/bin/env bash

mkdir -p ./tmp/

sudo cp ./vault.hcl /etc/vault.d/
sudo chown -R vault:vault /etc/vault.d/
# sudo chown -R o-rwx /etc/vault.d/

sudo systemctl enable vault.service
sudo systemctl start vault.service
read -p "Press Enter to continue..."

export VAULT_ADDR=http://127.0.0.1:8200
vault status

vault operator init -key-shares=1 -key-threshold=1 -format=json | tee ./tmp/vault-operator-init.json
vault status

jq -r .unseal_keys_b64[0] ./tmp/vault-operator-init.json | xargs vault operator unseal $1
vault status

jq -r .root_token ./tmp/vault-operator-init.json | vault login -
vault token lookup
