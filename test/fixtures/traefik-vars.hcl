# ------------------------------------------------------------------------------
# TRAEFIK VARIABLES
# This file is useful for testing packs that support Traefik integration.
#
# To deploy Traefik using this file, run:
#   nomad-pack registry add community github.com/hashicorp/nomad-pack-community-registry
#   nomad-pack run traefik -f traefik-vars.hcl --registry community
# ------------------------------------------------------------------------------
job_name = "traefik"

traefik_task = {
  driver       = "docker"
  version      = "v3.5.2"
  network_mode = "host"
}

traefik_group_network = {
  mode = "host"

  ports = {
    traefik = 8080
    http    = 80
  }
}

traefik_task_services = [
  {
    service_name       = "traefik-dashboard"
    service_port_label = "traefik"

    check_enabled  = true
    check_type     = "http"
    check_path     = "/ping"
    check_interval = "10s"
    check_timeout  = "2s"
  },
]

traefik_task_app_config = <<-EOF
  [entryPoints]
    [entryPoints.traefik]
      address = ":8080"

    [entryPoints.web]
      address = ":80"

      [entryPoints.web.forwardedHeaders]
        insecure = true

  [api]
    dashboard = true
    insecure = true

  [ping]
    entryPoint = "traefik"

  [providers.consulCatalog]
    prefix = "traefik"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "127.0.0.1:8500"
      scheme = "http"
EOF
