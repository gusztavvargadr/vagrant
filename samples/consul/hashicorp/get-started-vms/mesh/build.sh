#!/usr/bin/env bash

set -o errexit
set -o nounset

mkdir ./logs
mkdir ./tmp

nohup consul agent -dev -enable-script-checks -client 0.0.0.0 >./logs/consul.log 2>&1 &
