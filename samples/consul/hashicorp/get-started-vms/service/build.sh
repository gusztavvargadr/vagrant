#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir ./logs
mkdir ./config

nohup consul agent -dev -enable-script-checks -config-dir=./config -client 0.0.0.0 >./logs/consul.log 2>&1 &
