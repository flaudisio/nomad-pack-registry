job_name = "example-webapp-nfs-volumes"

image_name = "traefik/whoami"
image_tag  = "latest"

port = 80

task_nfs_volumes = [
  {
    server = "nfs-server.example.com"
    path   = "/srv/example-webapp-nfs-volume"
    target = "/data"
  },
]
