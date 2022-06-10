storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://{{ GetAllInterfaces | include \"name\" \"eth\" | sort \"-name\" | limit 1 | attr \"address\" }}:8200"

ui = true
