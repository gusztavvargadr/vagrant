service {
  name = "ssh"
  port = 22

  checks {
    tcp = "127.0.0.1:22"
    interval = "10s"
  }
}
