datacenter = "local"

data_dir = "/opt/consul"

bind_addr = "{{ GetAllInterfaces | include \"name\" \"eth\" | sort \"-name\" | limit 1 | attr \"address\" }}"

acl {
  enabled        = true
  default_policy = "deny"
  down_policy    = "extend-cache"
}

tls {
  defaults {
    verify_incoming = true
    verify_outgoing = true
    ca_file         = "/etc/consul.d/certs/consul-agent-ca.pem"
  }

  internal_rpc {
    verify_server_hostname = true
  }
}
