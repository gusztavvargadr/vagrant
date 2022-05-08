server     = false
retry_join = ["consul-bootstrap", "consul-server"]

client_addr = "0.0.0.0"

auto_encrypt {
  tls = true
}

ui_config {
  enabled = true
}
