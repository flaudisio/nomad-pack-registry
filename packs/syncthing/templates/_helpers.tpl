{{/* Job name */}}

[[- define "job_name" -]]
[[ var "job_name" . | quote ]]
[[- end -]]

{{/* Location */}}

[[ define "location" ]]
  [[ if var "region" . -]]
  region      = [[ var "region" . | quote ]]
  [[ end -]]
  [[ if var "namespace" . -]]
  namespace   = [[ var "namespace" . | quote ]]
  [[ end -]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]
[[- end ]]

{{/* Service - Traefik tags */}}

[[ define "traefik_tags" -]]
[[ if var "enable_traefik" . -]]
[[ $job_name := var "job_name" . -]]
        "traefik.enable=true",
        "traefik.http.routers.[[ $job_name ]].entrypoints=[[ var "traefik_entrypoints" . | join "," ]]",
        [[ if var "traefik_route_host" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=Host(`[[ var "traefik_route_host" . ]]`)",
        [[ end -]]
        [[ if var "traefik_route_path" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=Path(`[[ var "traefik_route_path" . ]]`)",
        [[ end -]]
        [[ if var "traefik_http_headers" . -]]
        "traefik.http.routers.[[ $job_name ]].middlewares=[[ $job_name ]]",
        [[ range $key, $value := var "traefik_http_headers" . -]]
        "traefik.http.middlewares.[[ $job_name ]].headers.[[ $key ]]=[[ $value ]]",
        [[ end -]]
        [[ end -]]
[[ end -]]
[[ end -]]
