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
    max_parallel      = [[ var "update_strategy.max_parallel" . ]]
    min_healthy_time  = [[ var "update_strategy.min_healthy_time" . | quote ]]
    healthy_deadline  = [[ var "update_strategy.healthy_deadline" . | quote ]]
    progress_deadline = [[ var "update_strategy.progress_deadline" . | quote ]]
    auto_revert       = [[ var "update_strategy.auto_revert" . ]]
    stagger           = [[ var "update_strategy.stagger" . | quote ]]
  }

  group [[ template "job_name" . ]] {
    count = 1

    ephemeral_disk {
      migrate = [[ var "ephemeral_disk.migrate" . ]]
      size    = [[ var "ephemeral_disk.size" . ]]
      sticky  = [[ var "ephemeral_disk.sticky" . ]]
    }

    [[- if $configure_group_volume ]]
    volume [[ var "group_volume_config.name" . | quote ]] {
      type      = [[ var "data_volume_type" . | default "host" | quote ]]
      source    = [[ var "group_volume_config.source" . | quote ]]
      read_only = false
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

    [[ if var "register_consul_service" . -]]
    service {
      name = "syncthing-webgui"
      port = "webgui"

      tags = [
        [[ template "traefik_tags" . -]]

        [[ range $tag := var "consul_service_tags" . ]]
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

      [[- if var "enable_nomad_variables" . ]]
      template {
        data = <<-EOT
          {{ range nomadVarList -}}
          {{ with nomadVar .Path -}}
          {{ range $k, $v := . -}}
          {{ $k }}="{{ $v }}"
          {{ end -}}
          {{ end -}}
          {{ end -}}
        EOT

        destination = "${NOMAD_SECRETS_DIR}/.secrets"
        env         = true
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
