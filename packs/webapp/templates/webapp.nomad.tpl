[[ $job_name := var "job_name" . -]]
[[ $port_label := "app" -]]

job "[[ $job_name ]]" {
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  [[ if var "region" . -]]
  region = "[[ var "region" . ]]"
  [[ end -]]

  [[ if var "namespace" . -]]
  namespace = [[ var "namespace" . | quote ]]
  [[ end -]]

  type = "service"

  [[ range $constraint := var "constraints" . -]]
  constraint {
    attribute = [[ $constraint.attribute | default "" | quote ]]
    operator  = [[ $constraint.operator | default "=" | quote ]]
    value     = [[ $constraint.value | default "" | quote ]]
  }
  [[ end ]]

  update {
    max_parallel = 1
    stagger      = "30s"
  }

  group "app" {
    count = [[ var "replicas" . ]]

    network {
      port "[[ $port_label ]]" {
        to = [[ var "port" . ]]
      }
    }

    [[ if var "register_service" . -]]
    service {
      name = "[[ $job_name ]]"
      port = "[[ $port_label ]]"

      tags = [
        [[ template "traefik_tags" . -]]

        [[ range $tag := var "service_extra_tags" . ]]
        [[ $tag | quote ]],
        [[- end ]]
      ]

      check {
        name     = "[[ var "health_check.name" . | default "alive" ]]"
        type     = "[[ var "health_check.type" . | default "http" ]]"
        port     = "[[ $port_label ]]"
        path     = "[[ var "health_check.path" . | default "/" ]]"
        method   = "[[ var "health_check.method" . | default "GET" ]]"
        interval = "[[ var "health_check.interval" . | default "10s" ]]"
        timeout  = "[[ var "health_check.timeout" . | default "2s" ]]"
      }
    }
    [[- end ]]

    task "server" {
      driver = "docker"

      config {
        image      = [[ var "image" . | quote ]]
        force_pull = true
        ports = [
          "[[ $port_label ]]",
        ]
      }

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
