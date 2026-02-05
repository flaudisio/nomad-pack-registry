job_name = "example-syncthing-group-volume"

enable_traefik     = true
traefik_route_host = "syncthing.example.com"

group_volume_config = {
  # Note: the volume directory must be writable by the UID/GID configured below
  name   = "data-dir"
  type   = "host"
  source = "example-syncthing-data" # See 'volume.hcl'
}

env = {
  PUID = "1500"
  PGID = "1500"
}
