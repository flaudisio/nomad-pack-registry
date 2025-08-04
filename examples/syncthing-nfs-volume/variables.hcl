enable_traefik     = true
traefik_route_host = "syncthing.example.com"

task_nfs_volume_config = {
  # Note: the path must be writable by the UID/GID configured below
  server = "nfs-server.example.com"
  path   = "/srv/syncthing-data"
}

env = {
  PUID = "1500"
  PGID = "1500"
}
