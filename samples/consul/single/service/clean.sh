#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

bash ../core/clean.sh

sudo systemctl stop consul.service
sudo systemctl disable consul.service

sudo rm -R /opt/consul/*
