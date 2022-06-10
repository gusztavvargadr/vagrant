#!/usr/bin/env bash

set -o errexit
set -o nounset

echo export VAULT_ADDR=http://127.0.0.1:8200
if [ -f ./tmp/init.json ]; then
  echo export VAULT_TOKEN=`jq -r .root_token ./tmp/init.json`
fi
