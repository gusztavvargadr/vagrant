datacenter = "local"

data_dir = "/opt/consul"

client_addr = "0.0.0.0"
bind_addr   = "{{ GetInterfaceIP \"eth1\" }}"

acl {
  enabled                  = true
  default_policy           = "deny"
  down_policy              = "extend-cache"
  enable_token_persistence = true
}

server           = true
bootstrap_expect = 1

ui_config {
  enabled = true
}
