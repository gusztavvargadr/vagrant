#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

sudo cp ./consul.hcl /etc/consul.d/
sudo chown -R consul:consul /etc/consul.d/
sudo chmod -R o-rwx /etc/consul.d/

sudo systemctl enable consul.service
sudo systemctl start consul.service
sleep 10s

bash ../core/build.sh
