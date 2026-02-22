Congrats! You deployed the CSI NFS plugin on Nomad.

To open the job status page in the browser, run:

  [[ if var "namespace" . -]]
  nomad job status -ui -namespace [[ var "namespace" . ]] [[ var "job_name_prefix" . ]]
  [[ else -]]
  nomad job status -ui [[ var "job_name_prefix" . ]]
  [[ end -]]
