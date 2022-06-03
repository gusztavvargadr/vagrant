#!/usr/bin/env bash

set -o errexit
set -o nounset

cd `dirname $0`

bash ../core/test.sh

consul services register ./service-ssh.hcl
