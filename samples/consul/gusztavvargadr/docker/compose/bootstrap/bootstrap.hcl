server           = true
bootstrap_expect = 1

cert_file = "/consul/config/certs/local-server-consul-0.pem"
key_file  = "/consul/config/certs/local-server-consul-0-key.pem"

auto_encrypt {
  allow_tls = true
}
