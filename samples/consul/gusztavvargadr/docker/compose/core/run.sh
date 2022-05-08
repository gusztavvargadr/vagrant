#!/usr/bin/env sh

set -o errexit
set -o nounset

cd core
echo encrypt = \"$(consul keygen)\" > gossip.hcl

mkdir certs
cd certs
consul tls ca create
consul tls cert create -server -dc local

cd ../..
chown -R consul:consul core
