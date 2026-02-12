job_name = "example-n8n-group-volumes"

image_name = "docker.n8n.io/n8nio/n8n"
image_tag  = "latest"

enable_traefik      = true
traefik_route_hosts = ["n8n.example.com"]

env = {
  N8N_EDITOR_BASE_URL                   = "http://n8n.example.com"
  WEBHOOK_URL                           = "http://n8n.example.com"
  N8N_PROXY_HOPS                        = "1"
  N8N_DIAGNOSTICS_ENABLED               = "false"
  N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "true"
  N8N_RUNNERS_ENABLED                   = "true"
  N8N_SECURE_COOKIE                     = "false" # Note: omit when using HTTPS
}

app_group_volume_config = {
  name   = "app-data-dir"
  type   = "host"
  source = "example-n8n-app-data" # See 'volume-app.hcl'
}

postgres_group_volume_config = {
  name   = "postgres-data-dir"
  type   = "host"
  source = "example-n8n-postgres-data" # See 'volume-postgres.hcl'
}
