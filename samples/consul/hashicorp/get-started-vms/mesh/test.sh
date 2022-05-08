#!/usr/bin/env bash

set -o errexit
set -o nounset

consul members

pushd ./tmp
wget -q https://github.com/hashicorp/demo-consul-101/releases/download/0.0.3.1/counting-service_linux_amd64.zip
unzip counting-service_linux_amd64.zip
wget -q https://github.com/hashicorp/demo-consul-101/releases/download/0.0.3.1/dashboard-service_linux_amd64.zip
unzip dashboard-service_linux_amd64.zip
popd

consul services register counting.hcl
consul services register dashboard.hcl
consul catalog services
consul config write intention-allow-config.hcl
read -p "Press Enter to continue..."

PORT=9003 ./tmp/counting-service_linux_amd64 > ./logs/counting.log 2>&1 &
consul connect envoy -sidecar-for counting -admin-bind localhost:19001 > ./logs/counting-proxy.log 2>&1 &
read -p "Press Enter to continue..."

PORT=9002 COUNTING_SERVICE_URL="http://localhost:5000" ./tmp/dashboard-service_linux_amd64 > ./logs/dashboard.log 2>&1 &
consul connect envoy -sidecar-for dashboard > ./logs/dashboard-proxy.log 2>&1 &
read -p "Press Enter to continue..."

consul config write intention-deny-config.hcl
read -p "Press Enter to continue..."

consul config write intention-allow-config.hcl
