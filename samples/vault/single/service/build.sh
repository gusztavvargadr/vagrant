#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

sudo cp ./vault.hcl /etc/vault.d/
sudo chown -R vault:vault /etc/vault.d/
sudo chmod -R o-rwx /etc/vault.d/

sudo systemctl enable vault.service
sudo systemctl start vault.service
sleep 5s

bash ../core/build.sh
