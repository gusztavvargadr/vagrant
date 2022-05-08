#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir ./logs

nohup consul agent -dev -node vagrant -client 0.0.0.0 >./logs/consul.log 2>&1 &
