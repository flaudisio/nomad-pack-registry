job_name = "example-syncthing-nfs-volume"

task_nfs_volume = {
  # Note: the path must be writable by the UID/GID configured below
  server = "nfs-server.example.com"
  path   = "/srv/syncthing-data"
}

env = {
  PUID = "1500"
  PGID = "1500"
}

enable_traefik = true

traefik_route_hosts = ["syncthing.example.com"]
