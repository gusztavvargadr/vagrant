server = true

tls {
  defaults {
    cert_file = "/etc/consul.d/certs/local-server-consul-0.pem"
    key_file  = "/etc/consul.d/certs/local-server-consul-0-key.pem"
  }
}

auto_encrypt {
  allow_tls = true
}
