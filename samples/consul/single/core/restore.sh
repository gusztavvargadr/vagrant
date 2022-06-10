#!/usr/bin/env bash

set -o errexit
set -o nounset

export CONSUL_VERSION=1.12.1

export DEBIAN_FRONTEND=noninteractive

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install consul=$CONSUL_VERSION-1 -y

sudo apt install jq net-tools -y

docker pull library/consul:$CONSUL_VERSION

export ENVOY_VERSION=1.22.0

curl -L https://func-e.io/install.sh | sudo bash -s -- -b /usr/local/bin
func-e use $ENVOY_VERSION
sudo cp ~/.func-e/versions/$ENVOY_VERSION/bin/envoy /usr/local/bin/
envoy --version
