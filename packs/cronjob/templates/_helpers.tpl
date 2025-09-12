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
