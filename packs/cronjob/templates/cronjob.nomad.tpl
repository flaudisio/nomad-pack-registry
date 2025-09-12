job [[ template "job_name" . ]] {
  [[- template "location" . ]]

  type = "batch"

  [[ range $constraint := var "constraints" . -]]
  constraint {
    attribute = [[ $constraint.attribute | default "" | quote ]]
    operator  = [[ $constraint.operator | default "=" | quote ]]
    value     = [[ $constraint.value | default "" | quote ]]
  }
  [[ end ]]

  periodic {
    enabled          = [[ var "periodic.enabled" . | default "true" ]]
    crons            = [[ var "periodic.crons" . | toStringList ]]
    time_zone        = [[ var "periodic.time_zone" . | default "UTC" | quote ]]
    prohibit_overlap = [[ var "periodic.prohibit_overlap" . | default "false" ]]
  }

  group [[ template "job_name" . ]] {
    count = [[ var "replicas" . ]]

    [[/* Ref: https://developer.hashicorp.com/nomad/docs/job-specification/restart#parameter-defaults */ -]]
    restart {
      attempts         = [[ var "restart.attempts" . | default "3" ]]
      delay            = [[ var "restart.delay" . | default "15s" | quote ]]
      interval         = [[ var "restart.interval" . | default "24h" | quote ]]
      mode             = [[ var "restart.mode" . | default "fail" | quote ]]
      render_templates = [[ var "restart.render_templates" . | default "false" ]]
    }

    task [[ template "job_name" . ]] {
      driver = "docker"

      config {
        image      = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        force_pull = [[ var "image_force_pull" . ]]
        [[- if var "task_command" . ]]
        command = [[ var "task_command" . | quote ]]
        [[- end ]]
        [[- if var "task_args" . ]]
        args = [[ var "task_args" . | toStringList ]]
        [[- end ]]
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
