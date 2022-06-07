#!/usr/bin/env bash

set -o errexit
set -o nounset

if [ ! -f ./tmp/acl.json ]; then
  consul acl bootstrap -format=json | tee ./tmp/acl.json
  eval `bash ./env.sh`

  consul acl set-agent-token agent $CONSUL_HTTP_TOKEN
  echo acl { tokens { agent = \"$CONSUL_HTTP_TOKEN\" } } > ./tmp/acl.hcl
else
  eval `bash ./env.sh`
fi

consul members
consul catalog nodes | grep server | awk '{ print "retry_join = [ \"" $3 "\" ]" }' > ./tmp/join.hcl

sudo cp ./tmp/*.hcl /etc/consul.d/
sudo chown -R consul:consul /etc/consul.d/
sudo chmod -R o-rwx /etc/consul.d/
