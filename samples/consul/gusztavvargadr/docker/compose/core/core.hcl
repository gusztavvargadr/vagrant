datacenter = "local"
log_level  = "INFO"

data_dir = "/consul/data"

retry_join = ["consul-server"]

verify_incoming        = true
verify_outgoing        = true
verify_server_hostname = true
ca_file                = "/consul/config/certs/consul-agent-ca.pem"
