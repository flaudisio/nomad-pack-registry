job_name = "example-webapp-local-volumes"

image_name = "traefik/whoami"
image_tag  = "latest"

port = 80

task_volumes = [
  "/tmp/example-webapp-local-volumes:/data-1",
]

group_volume_config = {
  name        = "app-data"
  source      = "example-webapp-data" # See 'volume.hcl'
  destination = "/data-2"
}
