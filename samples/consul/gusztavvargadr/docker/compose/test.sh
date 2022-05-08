#!/usr/bin/env bash

set -o errexit
set -o nounset

docker-compose up -d consul-core
sleep 5s

docker-compose up -d consul-bootstrap
sleep 5s

export CONSUL_HTTP_TOKEN=$(docker-compose exec consul-bootstrap sh -c "consul acl bootstrap -format=json | jq -r .SecretID" | tr -d '\r')
echo $CONSUL_HTTP_TOKEN
docker-compose exec -e CONSUL_HTTP_TOKEN consul-bootstrap sh -c "consul acl set-agent-token agent $CONSUL_HTTP_TOKEN"
docker-compose exec -e CONSUL_HTTP_TOKEN consul-bootstrap sh -c "echo acl { tokens { agent = \\\"$CONSUL_HTTP_TOKEN\\\" } } > core/acl-tokens.hcl"
sleep 5s

docker-compose up -d consul-server
sleep 5s

docker-compose up -d consul-client
sleep 5s

docker-compose scale consul-server=3
sleep 5s

docker-compose exec -e CONSUL_HTTP_TOKEN consul-bootstrap sh -c "consul leave"

docker container prune -f
docker image prune -f
docker volume prune -f
