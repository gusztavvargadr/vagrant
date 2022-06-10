datacenter = "local"

data_dir = "/opt/consul"

client_addr = "0.0.0.0"
bind_addr   = "{{ GetAllInterfaces | include \"name\" \"eth\" | sort \"-name\" | limit 1 | attr \"address\" }}"

ui_config {
  enabled = true
}

acl {
  enabled                  = true
  default_policy           = "deny"
  down_policy              = "extend-cache"
  enable_token_persistence = true
}

server           = true
bootstrap_expect = 1
