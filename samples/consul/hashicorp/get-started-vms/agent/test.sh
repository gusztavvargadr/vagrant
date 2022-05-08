#!/usr/bin/env bash

set -o errexit
set -o nounset

consul members
curl localhost:8500/v1/catalog/nodes
dig @127.0.0.1 -p 8600 vagrant.node.consul
