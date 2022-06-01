#!/usr/bin/env sh

set -o errexit
set -o nounset

if [ ! -f ./core/gossip.hcl ]; then
  cd ./core
  echo encrypt = \"$(consul keygen)\" > ./gossip.hcl

  mkdir ./certs
  cd ./certs
  consul tls ca create
  consul tls cert create -server -dc local

  cd ../..
  echo bootstrap_expect = 1 > ./config/bootstrap.hcl
fi
