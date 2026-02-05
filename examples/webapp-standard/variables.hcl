job_name = "example-webapp-standard"

# Ref: https://hub.docker.com/r/traefik/whoami/#whoami
image_name = "traefik/whoami"
image_tag  = "latest"

port = 8088

env = {
  WHOAMI_NAME        = "example-webapp-standard"
  WHOAMI_PORT_NUMBER = "8088"
}

enable_traefik = true

traefik_route_host = "whoami.example.com"
traefik_route_path = "/whoami"

traefik_custom_http_headers = {
  X-Nomad-Pack-Example = "true"
  X-Nomad-Pack-Name    = "webapp"
}

consul_service_check = {
  path   = "/health"
  method = "HEAD"
}
