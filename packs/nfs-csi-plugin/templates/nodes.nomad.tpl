job "[[ var "job_name_prefix" . ]]-nodes" {
  [[- template "location" . ]]

  type = "system"

  group "nodes" {
    count = 1

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
        privileged = true
      }

      csi_plugin {
        id        = "[[ var "plugin_id" . ]]"
        type      = "node"
        mount_dir = "/csi"
      }

      resources {
        cpu    = [[ var "node_resources.cpu" . | default "250" ]]
        memory = [[ var "node_resources.memory" . | default "128" ]]
      }
    }
  }
}
