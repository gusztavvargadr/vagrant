#!/usr/bin/env bash

set -o errexit
set -o nounset

consul config delete -kind service-intentions -name counting
consul services deregister dashboard.hcl
consul services deregister counting.hcl

pidof envoy | xargs kill
pidof dashboard-service_linux_amd64 | xargs kill
pidof counting-service_linux_amd64 | xargs kill

consul leave

rm -R ./logs

rm -R ./tmp
