[[ $configure_group_volume := and (var "group_volume_config.name" .) (var "group_volume_config.source" .) (var "group_volume_config.destination" .) -]]
[[ $port_label := "http" -]]

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
      port "[[ $port_label ]]" {
        [[- if ne (var "static_port" .) -1 ]]
        static = [[ var "static_port" . ]]
        [[- end ]]
        to = [[ var "port" . ]]
      }
    }

    [[- if var "register_consul_service" . ]]
    service {
      name = [[ template "job_name" . ]]
      port = "[[ $port_label ]]"

      tags = [
        [[ template "traefik_tags" . -]]

        [[ range $tag := var "consul_service_tags" . ]]
        [[ $tag | quote ]],
        [[- end ]]
      ]

      check {
        name     = "[[ var "consul_service_check.name" . | default "alive" ]]"
        type     = "[[ var "consul_service_check.type" . | default "http" ]]"
        port     = "[[ $port_label ]]"
        path     = "[[ var "consul_service_check.path" . | default "/" ]]"
        method   = "[[ var "consul_service_check.method" . | default "GET" ]]"
        interval = "[[ var "consul_service_check.interval" . | default "10s" ]]"
        timeout  = "[[ var "consul_service_check.timeout" . | default "2s" ]]"
      }
    }
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"
      [[- if var "task_user" . ]]
      user = [[ var "task_user" . | quote ]]
      [[- end ]]
      config {
        image      = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        force_pull = true
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
        ports = [
          "[[ $port_label ]]",
        ]
        [[- if var "task_volumes" . ]]
        volumes = [
          [[- range $volume := var "task_volumes" . ]]
          [[ $volume | quote ]],
          [[- end ]]
        ]
        [[- end ]]
        [[- if and (var "task_nfs_volume_config.server" .) (var "task_nfs_volume_config.path" .) (var "task_nfs_volume_config.target" .) ]]
        mount {
          type   = "volume"
          target = [[ var "task_nfs_volume_config.target" . | quote ]]
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
