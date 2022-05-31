#!/usr/bin/env bash

export VAULT_ADDR=http://127.0.0.1:8200

vault operator seal

sudo systemctl stop vault.service
sudo systemctl disable vault.service

sudo rm -R /opt/vault/data/*
rm -R ./tmp/
