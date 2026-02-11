job_name = "example-webapp-nfs-volume"

image_name = "traefik/whoami"
image_tag  = "latest"

port = 80

task_nfs_volume_config = {
  server = "nfs-server.example.com"
  path   = "/srv/example-webapp-nfs-volume"
  target = "/data"
}
