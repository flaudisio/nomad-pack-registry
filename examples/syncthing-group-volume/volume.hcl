name      = "example-syncthing-data"
type      = "host"
plugin_id = "mkdir"

parameters = {
  mode = "0700"
  # Same IDs defined in the 'PUID/PGID' environment variables
  uid = 1500
  gid = 1500
}

capability {
  access_mode     = "single-node-reader-only"
  attachment_mode = "file-system"
}

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
