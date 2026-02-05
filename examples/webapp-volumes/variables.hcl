job_name = "example-webapp-volumes"

# Ref: https://hub.docker.com/r/traefik/whoami/#whoami
image_name = "traefik/whoami"
image_tag  = "latest"

port = 80

task_volumes = [
  "/tmp/example-webapp-volumes:/data-1",
]

group_volume_config = {
  name        = "data"
  source      = "example-webapp-data" # See 'volume.hcl'
  destination = "/data-2"
}
