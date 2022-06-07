#!/usr/bin/env bash

set -o errexit
set -o nounset

if [ $# -eq 0 ]; then
  exit 1
fi

cd `dirname $0`

mkdir -p ./tmp/

if [ ! -f ./tmp/gossip.hcl ]; then
  echo encrypt = \"$(consul keygen)\" > ./tmp/gossip.hcl
fi

if [ ! -d ./tmp/certs/ ]; then
  mkdir -p ./tmp/certs/
  cd ./tmp/certs/

  consul tls ca create
  consul tls cert create -server -dc local

  cd ../../
fi

if [ ! -f ./tmp/acl.json ]; then
  echo bootstrap_expect = 1 > ./tmp/join.hcl
fi

sudo cp ./consul.hcl /etc/consul.d/
sudo cp ./$1.hcl /etc/consul.d/
sudo cp ./tmp/*.hcl /etc/consul.d/
sudo cp -R ./tmp/certs/ /etc/consul.d/
sudo chown -R consul:consul /etc/consul.d/
sudo chmod -R o-rwx /etc/consul.d/

sudo systemctl enable consul.service
sudo systemctl start consul.service
sleep 10s

bash ../core/build.sh

exit
