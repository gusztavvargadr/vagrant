#!/usr/bin/env bash

set -o errexit
set -o nounset

export DEBIAN_FRONTEND=noninteractive

export CONSUL_VERSION=1.11.4

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install consul=$CONSUL_VERSION -y

curl -L https://func-e.io/install.sh | sudo bash -s -- -b /usr/local/bin
func-e use 1.20.2
sudo cp ~/.func-e/versions/1.20.2/bin/envoy /usr/local/bin/
envoy --version

sudo apt install zip unzip -y

docker pull consul:$CONSUL_VERSION
