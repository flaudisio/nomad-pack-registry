job_name = "example-webapp-nginx"

image_name = "nginx"
image_tag  = "stable-alpine"

ports = {
  custom = { to = 80 }
}

port_label = "custom"

enable_traefik = true

traefik_route_hosts = ["nginx.example.com"]
traefik_route_path  = "/"

traefik_custom_http_headers = {
  X-Nomad-Pack-Example = "true"
  X-Nomad-Pack-Name    = "webapp"
}

service_check = {
  path = "/"
}
