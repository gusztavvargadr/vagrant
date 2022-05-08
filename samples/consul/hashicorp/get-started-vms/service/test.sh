#!/usr/bin/env bash

set -o errexit
set -o nounset

cp ./web.json.1 ./config/web.json
consul reload
read -p "Press Enter to continue..."

dig @127.0.0.1 -p 8600 web.service.consul
dig @127.0.0.1 -p 8600 web.service.consul SRV
dig @127.0.0.1 -p 8600 rails.web.service.consul
curl http://localhost:8500/v1/catalog/service/web
curl 'http://localhost:8500/v1/health/service/web?passing'

cp ./web.json.2 ./config/web.json
consul reload
read -p "Press Enter to continue..."

dig @127.0.0.1 -p 8600 web.service.consul
dig @127.0.0.1 -p 8600 web.service.consul SRV
dig @127.0.0.1 -p 8600 rails.web.service.consul
curl http://localhost:8500/v1/catalog/service/web
curl 'http://localhost:8500/v1/health/service/web?passing'
