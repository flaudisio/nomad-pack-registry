name      = "example-n8n-postgres-data"
type      = "host"
plugin_id = "mkdir"

parameters = {
  mode = "0700"
  # Default IDs in the Postgres image
  uid = 70
  gid = 70
}

capability {
  access_mode     = "single-node-reader-only"
  attachment_mode = "file-system"
}

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
