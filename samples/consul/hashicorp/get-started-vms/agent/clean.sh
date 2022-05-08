#!/usr/bin/env bash

set -o errexit
set -o nounset

consul leave

rm -R ./logs
