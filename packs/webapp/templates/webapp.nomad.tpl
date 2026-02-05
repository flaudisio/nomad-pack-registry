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

    network {
      port "[[ $port_label ]]" {
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

      config {
        image      = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        force_pull = true
        ports = [
          "[[ $port_label ]]",
        ]
      }

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
