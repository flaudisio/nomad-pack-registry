name      = "example-n8n-app-data"
type      = "host"
plugin_id = "mkdir"

parameters = {
  mode = "0700"
  # Default IDs in the n8n image
  uid = 1000
  gid = 1000
}

capability {
  access_mode     = "single-node-reader-only"
  attachment_mode = "file-system"
}

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
