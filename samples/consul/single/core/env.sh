#!/usr/bin/env bash

set -o errexit
set -o nounset

echo export CONSUL_HTTP_ADDR=127.0.0.1:8500
if [ -f ./tmp/acl.json ]; then
  echo export CONSUL_HTTP_TOKEN=`jq -r .SecretID ./tmp/acl.json`
fi
