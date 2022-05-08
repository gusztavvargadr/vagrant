#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir ./logs

nohup vault server -dev -dev-listen-address=0.0.0.0:8200 >./logs/vault.log 2>&1 &
