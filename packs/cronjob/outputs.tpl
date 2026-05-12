Congrats! You deployed the [[ var "job_name" . ]] job on Nomad using the [[ meta "pack.name" . ]] pack.

To open the job status page in the browser, run:

  [[ if var "namespace" . -]]
  nomad job status -ui -namespace [[ var "namespace" . ]] [[ var "job_name" . ]]
  [[ else -]]
  nomad job status -ui [[ var "job_name" . ]]
  [[ end -]]
