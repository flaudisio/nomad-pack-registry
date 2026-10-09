job_name = "example-webapp-entrypoint-args"

image_name = "caddy"
image_tag  = "2-alpine"

ports = {
  app = { to = 80 }
}

task_entrypoint = ["caddy"]

task_args = ["file-server", "--listen", ":80", "--root", "/usr/share/caddy"]

service_check = {
  path = "/"
}
