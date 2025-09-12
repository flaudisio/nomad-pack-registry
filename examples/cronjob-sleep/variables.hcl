job_name = "cronjob-sleep"

image_name = "alpine"
image_tag  = "3.22"

task_command = "sh"
task_args    = ["-c", "date ; echo 'Sleeping...' ; sleep 5 ; date"]

periodic = {
  enabled = true
  crons = [
    "*/1 * * * *",
  ]
  time_zone        = "America/Sao_Paulo"
  prohibit_overlap = true
}

restart = {
  attempts = 1
}
