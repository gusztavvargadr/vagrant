#!/usr/bin/env bash

set -o errexit
set -o nounset

pidof vault | xargs kill

rm -R ./logs
