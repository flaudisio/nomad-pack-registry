job "[[ var "job_name_prefix" . ]]-controller" {
  [[- template "location" . ]]

  type = "service"

  group "controller" {
    count = [[ var "controller_replicas" . ]]

    task "plugin" {
      driver = "docker"

      config {
        image = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        args = [
          "-v=5",
          "--nodeid=${attr.unique.hostname}",
          "--endpoint=unix://csi/csi.sock",
          "--logtostderr",
        ]
      }

      csi_plugin {
        id        = "[[ var "plugin_id" . ]]"
        type      = "controller"
        mount_dir = "/csi"
      }

      resources {
        cpu    = [[ var "controller_resources.cpu" . | default "250" ]]
        memory = [[ var "controller_resources.memory" . | default "128" ]]
      }
    }
  }
}
