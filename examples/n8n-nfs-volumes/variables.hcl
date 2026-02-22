job_name = "example-n8n-nfs-volumes"

image_name = "docker.n8n.io/n8nio/n8n"
image_tag  = "latest"

env = {
  N8N_EDITOR_BASE_URL                   = "http://n8n.example.com"
  WEBHOOK_URL                           = "http://n8n.example.com"
  N8N_PROXY_HOPS                        = "1"
  N8N_DIAGNOSTICS_ENABLED               = "false"
  N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "true"
  N8N_RUNNERS_ENABLED                   = "true"
  N8N_SECURE_COOKIE                     = "false" # Note: omit when using HTTPS
}

app_task_nfs_volume_config = {
  server = "nfs-server.example.com"
  path   = "/srv/n8n/n8n-data"
}

postgres_task_nfs_volume_config = {
  server = "nfs-server.example.com"
  path   = "/srv/n8n/postgres-data"
}

enable_traefik = true

traefik_route_hosts = ["n8n.example.com"]
