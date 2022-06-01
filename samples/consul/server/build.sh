mkdir -p ./tmp/

sudo cp ./consul.hcl /etc/consul.d/
sudo chown -R consul:consul /etc/consul.d/
# sudo chown -R o-rwx /etc/consul.d/

sudo systemctl enable consul.service
sudo systemctl start consul.service
read -p "Press Enter to continue..."

consul acl bootstrap -format=json | tee ./tmp/consul-acl-bootstrap.json
export CONSUL_HTTP_TOKEN=`jq -r .SecretID ./tmp/consul-acl-bootstrap.json`
consul info

consul acl set-agent-token agent $CONSUL_HTTP_TOKEN
consul info

consul members
