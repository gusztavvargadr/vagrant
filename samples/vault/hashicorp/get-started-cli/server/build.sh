#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir ./logs

export VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200
export VAULT_DEV_ROOT_TOKEN_ID=root

nohup vault server -dev >./logs/vault.log 2>&1 &
