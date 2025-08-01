job_name = "webapp-complete"

image = "traefik/whoami:latest"
port  = 8088

env = {
  WHOAMI_PORT_NUMBER = "8088"
}
