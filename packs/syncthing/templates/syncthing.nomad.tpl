[[ $configure_group_volume := and (var "group_volume_config.name" .) (var "group_volume_config.source" .) -]]

job [[ template "job_name" . ]] {
  [[- template "location" . ]]

  type = "service"

  [[ range $constraint := var "constraints" . -]]
  constraint {
    attribute = [[ $constraint.attribute | default "" | quote ]]
    operator  = [[ $constraint.operator | default "=" | quote ]]
    value     = [[ $constraint.value | default "" | quote ]]
  }
  [[ end ]]

  update {
    max_parallel      = [[ var "update_strategy.max_parallel" . | default "1" ]]
    min_healthy_time  = [[ var "update_strategy.min_healthy_time" . | default "10s" | quote ]]
    healthy_deadline  = [[ var "update_strategy.healthy_deadline" . | default "5m" | quote ]]
    progress_deadline = [[ var "update_strategy.progress_deadline" . | default "10m" | quote ]]
    auto_revert       = [[ var "update_strategy.auto_revert" . | default "false" ]]
    stagger           = [[ var "update_strategy.stagger" . | default "30s" | quote ]]
  }

  group [[ template "job_name" . ]] {
    count = 1

    ephemeral_disk {
      migrate = [[ var "ephemeral_disk.migrate" . | default "true" ]]
      size    = [[ var "ephemeral_disk.size" . | default "500" ]]
      sticky  = [[ var "ephemeral_disk.sticky" . | default "true" ]]
    }

    [[- if $configure_group_volume ]]
    volume [[ var "group_volume_config.name" . | quote ]] {
      type      = [[ var "group_volume_config.type" . | default "host" | quote ]]
      source    = [[ var "group_volume_config.source" . | quote ]]
      read_only = [[ var "group_volume_config.read_only" . | default "false" ]]
      [[- if var "group_volume_config.access_mode" . ]]
      access_mode = [[ var "group_volume_config.access_mode" . | quote ]]
      [[- end ]]
      [[- if var "group_volume_config.attachment_mode" . ]]
      attachment_mode = [[ var "group_volume_config.attachment_mode" . | quote ]]
      [[- end ]]
      [[- if var "group_volume_config.sticky" . ]]
      sticky = [[ var "group_volume_config.sticky" . ]]
      [[- end ]]
      [[- if var "group_volume_config.per_alloc" . ]]
      per_alloc = [[ var "group_volume_config.per_alloc" . ]]
      [[- end ]]
      [[- if var "group_volume_config.mount_options" . ]]
      mount_options {
        [[- if var "group_volume_config.mount_options.fs_type" . ]]
        fs_type = [[ var "group_volume_config.mount_options.fs_type" . | quote ]]
        [[- end ]]
        [[- if var "group_volume_config.mount_options.mount_flags" . ]]
        mount_flags = [[ var "group_volume_config.mount_options.mount_flags" . | toStringList ]]
        [[- end ]]
      }
      [[- end ]]
    }
    [[- end ]]

    network {
      [[/* Ref: https://docs.syncthing.net/users/firewall */ -]]
      port "webgui" {
        static = [[ var "webgui_port" . ]]
        to     = 8384
      }
      port "sync-protocol" {
        static = [[ var "sync_protocol_port" . ]]
        to     = 22000
      }
    }

    [[ if var "register_service" . -]]
    service {
      name = "syncthing-webgui"
      port = "webgui"

      tags = [
        [[ template "traefik_tags" . -]]

        [[ range $tag := var "service_tags" . ]]
        [[ $tag | quote ]],
        [[- end ]]
      ]

      check {
        name     = "alive"
        type     = "http"
        path     = "/rest/noauth/health"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      config {
        image        = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        force_pull   = true
        network_mode = [[ var "network_mode" . | quote ]]
        ports = [
          "webgui",
          "sync-protocol",
        ]

        [[- if and (var "task_nfs_volume_config.server" .) (var "task_nfs_volume_config.path" .) ]]
        mount {
          type   = "volume"
          target = [[ var "container_data_dir" . | quote ]]
          [[/*
            Refs:
            - https://docs.docker.com/engine/storage/volumes/#options-for---mount
            - https://docs.docker.com/engine/storage/volumes/#create-a-service-which-creates-an-nfs-volume
            - https://docs.docker.com/reference/compose-file/services/#volumes
          */ -]]
          volume_options {
            no_copy = true
            driver_config {
              options {
                type   = "nfs"
                device = ":[[ var "task_nfs_volume_config.path" . ]]"
                o      = "addr=[[ var "task_nfs_volume_config.server" . ]],[[ var "task_nfs_volume_config.nfs_opts" . | default "rw,nolock,soft,nfsvers=4" ]]"
              }
            }
          }
        }
        [[- end ]]
      }

      [[- if $configure_group_volume ]]
      volume_mount {
        volume      = [[ var "group_volume_config.name" . | quote ]]
        destination = [[ var "container_data_dir" . | quote ]]
        read_only   = false
      }
      [[- end ]]

      env {
        [[- range $key, $value := var "env" . ]]
        [[ $key ]] = [[ $value | quote ]]
        [[- end ]]
      }

      resources {
        cpu    = [[ var "resources.cpu" . | default "100" ]]
        memory = [[ var "resources.memory" . | default "128" ]]
        [[- if var "resources.cores" . ]]
        cores = [[ var "resources.cores" . ]]
        [[- end ]]
        [[- if var "resources.memory_max" . ]]
        memory_max = [[ var "resources.memory_max" . ]]
        [[- end ]]
        [[- if var "resources.secrets" . ]]
        secrets = [[ var "resources.secrets" . ]]
        [[- end ]]
      }
    }
  }
}
