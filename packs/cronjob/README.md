<!-- BEGIN_PACK_METADATA -->
# cronjob

This pack runs a periodic batch job.
<!-- END_PACK_METADATA -->

## How to use this pack?

- See the [repository README](../../README.md) for instructions on how to use packs.
- See the [examples](../../examples) folder for sample usage.
- See [variables.hcl](variables.hcl) for all the variables supported by this pack.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The container image name | `string` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The container image tag | `string` | n/a | yes |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | The name of the job | `string` | n/a | yes |
| <a name="input_periodic"></a> [periodic](#input\_periodic) | Periodic block configuration | <pre>object({<br/>    enabled          = bool<br/>    crons            = list(string)<br/>    time_zone        = string<br/>    prohibit_overlap = bool<br/>  })</pre> | n/a | yes |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | A list of constraints for restricting the set of eligible nodes to place the job | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "dc1"<br/>]</pre> | no |
| <a name="input_enable_nomad_secrets"></a> [enable\_nomad\_secrets](#input\_enable\_nomad\_secrets) | Whether all Nomad secrets readable by the job should be loaded and exposed as environment variables to the container | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | A map of environment variables to populate the task's environment before starting | `map(string)` | `{}` | no |
| <a name="input_image_force_pull"></a> [image\_force\_pull](#input\_image\_force\_pull) | Whether to always pull the most recent image instead of using existing local image | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the job should be placed | `string` | `""` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where the job should be placed | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the job should be placed | `string` | `""` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of job instances to deploy | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources to assign to the service task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      cores      = number<br/>      memory     = number<br/>      memory_max = number<br/>      secrets    = number<br/>    }<br/>  )</pre> | <pre>{<br/>  "cores": null,<br/>  "cpu": 100,<br/>  "memory": 128,<br/>  "memory_max": null,<br/>  "secrets": null<br/>}</pre> | no |
| <a name="input_restart"></a> [restart](#input\_restart) | Restart block configuration | <pre>object({<br/>    attempts         = number<br/>    delay            = string<br/>    interval         = string<br/>    mode             = string<br/>    render_templates = bool<br/>  })</pre> | `{}` | no |
| <a name="input_task_args"></a> [task\_args](#input\_task\_args) | A list of arguments to the optional `task_command` | `list(string)` | `[]` | no |
| <a name="input_task_command"></a> [task\_command](#input\_task\_command) | The command to run when starting the container | `string` | `""` | no |
<!-- END_TF_DOCS -->
