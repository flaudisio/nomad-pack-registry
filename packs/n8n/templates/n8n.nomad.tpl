job "[[ var "job_name" . ]]" {
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

  [[ $configure_app_group_volume := and (var "app_group_volume_config.name" .) (var "app_group_volume_config.source" .) -]]
  group "app" {
    count = [[ var "replicas" . ]]

    [[- if $configure_app_group_volume ]]
    volume [[ var "app_group_volume_config.name" . | quote ]] {
      type      = [[ var "app_group_volume_config.type" . | default "host" | quote ]]
      source    = [[ var "app_group_volume_config.source" . | quote ]]
      read_only = false
      [[- if var "app_group_volume_config.access_mode" . ]]
      access_mode = [[ var "app_group_volume_config.access_mode" . | quote ]]
      [[- end ]]
      [[- if var "app_group_volume_config.attachment_mode" . ]]
      attachment_mode = [[ var "app_group_volume_config.attachment_mode" . | quote ]]
      [[- end ]]
    }
    [[- end ]]

    network {
      port "http" {
        [[- if ne (var "static_port" .) -1 ]]
        static = [[ var "static_port" . ]]
        [[- end ]]
        to = 5678
      }
    }

    service {
      name = "[[ var "job_name" . ]]-app"
      port = "http"

      tags = [
        [[ template "traefik_tags" . -]]

        [[ range $tag := var "consul_service_tags" . ]]
        [[ $tag | quote ]],
        [[- end ]]
      ]

      check {
        name     = "alive"
        type     = "http"
        path     = "/healthz/readiness"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "app" {
      driver = "docker"

      config {
        image      = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        force_pull = true
        ports      = ["http"]

        [[- if and (var "app_task_nfs_volume_config.server" .) (var "app_task_nfs_volume_config.path" .) ]]
        mount {
          type   = "volume"
          target = "/home/node/.n8n"
          volume_options {
            no_copy = true
            driver_config {
              options {
                type   = "nfs"
                device = ":[[ var "app_task_nfs_volume_config.path" . ]]"
                o      = "addr=[[ var "app_task_nfs_volume_config.server" . ]],[[ var "app_task_nfs_volume_config.nfs_opts" . | default "rw,nolock,soft,nfsvers=4" ]]"
              }
            }
          }
        }
        [[- end ]]
      }

      [[- if $configure_app_group_volume ]]
      volume_mount {
        volume      = [[ var "app_group_volume_config.name" . | quote ]]
        destination = "/home/node/.n8n"
        read_only   = false
      }
      [[- end ]]

      template {
        data = <<-EOT
          {{ with nomadVar (printf "nomad/jobs/%v" (env "NOMAD_JOB_NAME")) -}}
          DB_POSTGRESDB_PASSWORD="{{ .POSTGRES_PASSWORD }}"
          N8N_ENCRYPTION_KEY="{{ .N8N_ENCRYPTION_KEY }}"
          {{ end -}}
        EOT

        destination = "${NOMAD_SECRETS_DIR}/secrets.env"
        env         = true
      }

      template {
        data = <<-EOT
          {{ range service "[[ template "postgres_service_name" . ]]" -}}
          DB_POSTGRESDB_HOST="{{ .Address }}"
          DB_POSTGRESDB_PORT="{{ .Port }}"
          {{ end -}}
        EOT

        destination = "${NOMAD_TASK_DIR}/postgres.env"
        change_mode = "restart"
        env         = true
      }

      env {
        DB_TYPE                = "postgresdb"
        DB_POSTGRESDB_DATABASE = [[ var "postgres_db_name" . | quote ]]
        DB_POSTGRESDB_USER     = [[ var "postgres_db_user" . | quote ]]
        TZ                     = [[ var "timezone" . | quote ]]
        GENERIC_TIMEZONE       = [[ var "timezone" . | quote ]]
        [[- range $key, $value := var "env" . ]]
        [[ $key ]] = [[ $value | quote ]]
        [[- end ]]
      }

      resources {
        cpu        = [[ var "resources.cpu" . | default "300" ]]
        memory     = [[ var "resources.memory" . | default "512" ]]
        memory_max = [[ var "resources.memory_max" . | default "1024" ]]
      }
    }
  }

  [[ $configure_postgres_group_volume := and (var "postgres_group_volume_config.name" .) (var "postgres_group_volume_config.source" .) -]]
  group "postgres" {
    count = 1

    [[- if $configure_postgres_group_volume ]]
    volume [[ var "postgres_group_volume_config.name" . | quote ]] {
      type      = [[ var "postgres_group_volume_config.type" . | default "host" | quote ]]
      source    = [[ var "postgres_group_volume_config.source" . | quote ]]
      read_only = false
      [[- if var "postgres_group_volume_config.access_mode" . ]]
      access_mode = [[ var "postgres_group_volume_config.access_mode" . | quote ]]
      [[- end ]]
      [[- if var "postgres_group_volume_config.attachment_mode" . ]]
      attachment_mode = [[ var "postgres_group_volume_config.attachment_mode" . | quote ]]
      [[- end ]]
    }
    [[- end ]]

    network {
      port "postgres" {
        to = 5432
      }
    }

    task "postgres" {
      service {
        name = "[[ template "postgres_service_name" . ]]"
        port = "postgres"

        check {
          type     = "script"
          command  = "sh"
          args     = ["-c", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
          interval = "10s"
          timeout  = "2s"
        }
      }

      driver = "docker"

      config {
        image      = "[[ var "postgres_image_name" . ]]:[[ var "postgres_image_tag" . ]]"
        force_pull = true
        ports      = ["postgres"]

        [[- if and (var "postgres_task_nfs_volume_config.server" .) (var "postgres_task_nfs_volume_config.path" .) ]]
        mount {
          type   = "volume"
          target = "/var/lib/postgresql/data"
          volume_options {
            no_copy = true
            driver_config {
              options {
                type   = "nfs"
                device = ":[[ var "postgres_task_nfs_volume_config.path" . ]]"
                o      = "addr=[[ var "postgres_task_nfs_volume_config.server" . ]],[[ var "postgres_task_nfs_volume_config.nfs_opts" . | default "rw,nolock,soft,nfsvers=4" ]]"
              }
            }
          }
        }
        [[- end ]]
      }

      [[- if $configure_postgres_group_volume ]]
      volume_mount {
        volume      = [[ var "postgres_group_volume_config.name" . | quote ]]
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }
      [[- end ]]

      template {
        data = <<-EOT
          {{ with nomadVar (printf "nomad/jobs/%v" (env "NOMAD_JOB_NAME")) -}}
          POSTGRES_PASSWORD="{{ .POSTGRES_PASSWORD }}"
          {{ end -}}
        EOT

        destination = "${NOMAD_SECRETS_DIR}/secrets.env"
        change_mode = "noop"
        env         = true
      }

      env {
        POSTGRES_DB   = [[ var "postgres_db_name" . | quote ]]
        POSTGRES_USER = [[ var "postgres_db_user" . | quote ]]
      }

      resources {
        cpu    = 150
        memory = 512
      }
    }
  }
}
