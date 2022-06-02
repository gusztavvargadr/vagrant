#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

bash ../core/clean.sh

sudo systemctl stop vault.service
sudo systemctl disable vault.service

sudo rm -R /opt/vault/data/*
