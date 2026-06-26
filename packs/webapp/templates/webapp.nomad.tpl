[[ $configure_group_volume := and (var "group_volume_config.name" .) (var "group_volume_config.source" .) (var "group_volume_config.destination" .) -]]
[[ $app_port := var "app_port" . -]]

job [[ template "job_name" . ]] {
  [[- template "location" . ]]

  type = "service"

  [[- range $constraint := var "constraints" . ]]
  constraint {
    attribute = [[ $constraint.attribute | default "" | quote ]]
    operator  = [[ $constraint.operator | default "=" | quote ]]
    value     = [[ $constraint.value | default "" | quote ]]
  }
  [[- end ]]

  update {
    max_parallel      = [[ var "update_strategy.max_parallel" . | default "1" ]]
    min_healthy_time  = [[ var "update_strategy.min_healthy_time" . | default "10s" | quote ]]
    healthy_deadline  = [[ var "update_strategy.healthy_deadline" . | default "5m" | quote ]]
    progress_deadline = [[ var "update_strategy.progress_deadline" . | default "10m" | quote ]]
    auto_revert       = [[ var "update_strategy.auto_revert" . | default "false" ]]
    stagger           = [[ var "update_strategy.stagger" . | default "30s" | quote ]]
  }

  group [[ template "job_name" . ]] {
    count = [[ var "replicas" . ]]

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
      [[- range $label, $port := var "ports" . ]]
      port [[ $label | quote ]] {
        [[- if $port.static ]]
        static = [[ $port.static ]]
        [[- end ]]
        to = [[ $port.to ]]
      }
      [[- end ]]
    }

    [[- if var "register_service" . ]]
    service {
      name = [[ template "job_name" . ]]
      port = [[ $app_port | quote ]]

      tags = [
        [[ template "traefik_tags" . -]]

        [[ range $tag := var "service_tags" . ]]
        [[ $tag | quote ]],
        [[- end ]]
      ]

      check {
        name     = "[[ var "service_check.name" . | default "alive" ]]"
        type     = "[[ var "service_check.type" . | default "http" ]]"
        port     = "[[ $app_port ]]"
        path     = "[[ var "service_check.path" . | default "/" ]]"
        method   = "[[ var "service_check.method" . | default "GET" ]]"
        interval = "[[ var "service_check.interval" . | default "10s" ]]"
        timeout  = "[[ var "service_check.timeout" . | default "2s" ]]"
      }
    }
    [[- end ]]

    shutdown_delay = [[ var "shutdown_delay" . | quote ]]

    task [[ template "job_name" . ]] {
      driver = "docker"
      [[- if var "task_user" . ]]
      user = [[ var "task_user" . | quote ]]
      [[- end ]]
      [[- if var "task_kill_timeout" . ]]
      kill_timeout = [[ var "task_kill_timeout" . | quote ]]
      [[- end ]]
      config {
        image      = "[[ var "image_name" . ]][[ template "image_sep" . ]][[ var "image_tag" . ]]"
        force_pull = true
        [[- if var "network_mode" . ]]
        network_mode = [[ var "network_mode" . | quote ]]
        [[- end ]]
        [[- if var "task_command" . ]]
        command = [[ var "task_command" . | quote ]]
        [[- end ]]
        [[- if var "task_args" . ]]
        args = [
          [[- range $arg := var "task_args" . ]]
          [[ $arg | quote ]],
          [[- end ]]
        ]
        [[- end ]]
        [[- if var "task_group_add" . ]]
        group_add = [
          [[- range $group := var "task_group_add" . ]]
          [[ $group | quote ]],
          [[- end ]]
        ]
        [[- end ]]
        ports = [
          [[- range $label, $port := var "ports" . ]]
          [[ $label | quote ]],
          [[- end ]]
        ]
        [[- if var "task_volumes" . ]]
        volumes = [
          [[- range $volume := var "task_volumes" . ]]
          [[ $volume | quote ]],
          [[- end ]]
        ]
        [[- end ]]
        [[- range $nfs_volume := var "task_nfs_volumes" . ]]
        [[- if and $nfs_volume.server $nfs_volume.path $nfs_volume.target ]]
        mount {
          type   = "volume"
          target = [[ $nfs_volume.target | quote ]]
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
                device = ":[[ $nfs_volume.path ]]"
                o      = "addr=[[ $nfs_volume.server ]],[[ $nfs_volume.nfs_opts | default "rw,nolock,soft,nfsvers=4" ]]"
              }
            }
          }
        }
        [[- end ]]
        [[- end ]]
        [[- if var "task_devices" . ]]
        devices = [
          {
            [[- range $device := var "task_devices" . ]]
            host_path      = [[ $device.host_path | quote ]]
            container_path = [[ $device.container_path | default $device.host_path | quote ]]
            [[- if $device.cgroup_permissions ]]
            cgroup_permissions = [[ $device.cgroup_permissions | quote ]]
            [[- end ]]
            [[- end ]]
          },
        ]
        [[- end ]]
      }

      [[- if $configure_group_volume ]]
      volume_mount {
        volume      = [[ var "group_volume_config.name" . | quote ]]
        destination = [[ var "group_volume_config.destination" . | quote ]]
        read_only   = false
      }
      [[- end ]]

      [[- if var "enable_nomad_secrets" . ]]
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

      [[- range $template := var "task_templates" . ]]
      [[- if and $template.data $template.destination ]]
      template {
        data        = <<-EOT
          [[ $template.data | nindent 10 | trim ]]
        EOT
        destination = [[ $template.destination | quote ]]
        env         = [[ $template.env | default "false" ]]
        change_mode = [[ $template.change_mode | default "restart" | quote ]]
      }
      [[- end ]]
      [[- end ]]

      [[- range $template := var "task_templates_from_files" . ]]
      [[- if and $template.src_file $template.destination ]]
      template {
        data        = <<-EOT
          [[ fileContents $template.src_file | nindent 10 | trim ]]
        EOT
        destination = [[ $template.destination | quote ]]
        env         = [[ $template.env | default "false" ]]
        change_mode = [[ $template.change_mode | default "restart" | quote ]]
      }
      [[- end ]]
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
