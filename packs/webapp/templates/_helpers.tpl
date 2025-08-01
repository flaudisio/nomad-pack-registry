[[ define "traefik_tags" -]]
[[ $job_name := var "job_name" . -]]
        "traefik.enable=true",
        "traefik.http.routers.[[ $job_name ]].entrypoints=[[ var "traefik_entrypoint" . ]]",
        [[ if var "service_domain" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=Host(`[[ var "service_domain" . ]]`)",
        [[ end -]]
        [[ if var "service_path" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=Path(`[[ var "service_path" . ]]`)",
        [[ end -]]
        [[ if var "service_custom_headers" . -]]
        "traefik.http.routers.[[ $job_name ]].middlewares=[[ $job_name ]]",
        [[ range $key, $value := var "service_custom_headers" . -]]
        "traefik.http.middlewares.[[ $job_name ]].headers.[[ $key ]]=[[ $value ]]",
        [[ end -]]
        [[ end -]]
[[ end -]]
