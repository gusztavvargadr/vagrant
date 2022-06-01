#!/usr/bin/env bash

export CONSUL_HTTP_TOKEN=`jq -r .SecretID ./tmp/consul-acl-bootstrap.json`

consul leave

sudo systemctl stop consul.service
sudo systemctl disable consul.service

sudo rm -R /opt/consul/*
rm -R ./tmp/
