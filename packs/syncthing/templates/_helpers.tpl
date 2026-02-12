[[/* Job name */]]

[[- define "job_name" -]]
[[ var "job_name" . | quote ]]
[[- end -]]

[[/* Location */]]

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

[[/* Service - Traefik tags */]]

[[ define "traefik_tags" -]]
[[ if var "enable_traefik" . -]]
[[ $job_name := var "job_name" . -]]
        "traefik.enable=true",
        "traefik.http.routers.[[ $job_name ]].entrypoints=[[ var "traefik_entrypoints" . | join "," ]]",
        [[ if var "traefik_route_hosts" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=[[ range $idx, $host := var "traefik_route_hosts" . ]][[ if gt $idx 0 ]] || [[ end ]]Host(`[[ $host ]]`)[[ end ]]",
        [[ end -]]
        [[ if var "traefik_route_path" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=Path(`[[ var "traefik_route_path" . ]]`)",
        [[ end -]]
        [[ range var "traefik_route_custom_rules" . -]]
        "traefik.http.routers.[[ $job_name ]].rule=[[ . ]]",
        [[ end -]]
        [[ if var "traefik_custom_http_headers" . -]]
        "traefik.http.routers.[[ $job_name ]].middlewares=[[ $job_name ]]@consulcatalog",
        [[ range $key, $value := var "traefik_custom_http_headers" . -]]
        "traefik.http.middlewares.[[ $job_name ]].headers.customrequestheaders.[[ $key ]]=[[ $value ]]",
        [[ end -]]
        [[ end -]]
[[ end -]]
[[ end -]]
