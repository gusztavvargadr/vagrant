#!/usr/bin/env bash

set -o errexit
set -o nounset

docker compose up -d consul-server
sleep 5s

export CONSUL_HTTP_TOKEN=$(docker compose exec consul-server sh -c "consul acl bootstrap -format=json | jq -r .SecretID" | tr -d '\r')
echo $CONSUL_HTTP_TOKEN
docker compose exec -e CONSUL_HTTP_TOKEN consul-server sh -c "consul acl set-agent-token agent $CONSUL_HTTP_TOKEN"
docker compose exec -e CONSUL_HTTP_TOKEN consul-server sh -c "echo acl { tokens { agent = \\\"$CONSUL_HTTP_TOKEN\\\" } } > core/acl-tokens.hcl"
sleep 5s

docker compose up -d consul-client
read -p "Press Enter to continue..."

docker compose up -d --scale consul-server=3 --no-recreate consul-server
