<!-- BEGIN_PACK_METADATA -->
# webapp

This pack runs a single system job that can be accessed via HTTP.
<!-- END_PACK_METADATA -->

## How to use this pack?

- See the [repository README](../../README.md) for instructions on how to use packs.
- See the [examples](../../examples) folder for sample usage.
- See [variables.hcl](variables.hcl) for all the variables supported by this pack.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The container image name | `string` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The container image tag | `string` | n/a | yes |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | The name of the job | `string` | n/a | yes |
| <a name="input_app_port"></a> [app\_port](#input\_app\_port) | The label of the application's default port (used e.g. by service checks) | `string` | `"app"` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | A list of constraints for restricting the set of eligible nodes to place the job | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "dc1"<br/>]</pre> | no |
| <a name="input_disable_builtin_healthchecks"></a> [disable\_builtin\_healthchecks](#input\_disable\_builtin\_healthchecks) | Whether to disable `HEALTHCHECK` directives built into the task container | `bool` | `true` | no |
| <a name="input_enable_nomad_secrets"></a> [enable\_nomad\_secrets](#input\_enable\_nomad\_secrets) | Whether all Nomad secrets readable by the job should be loaded and exposed as environment variables to the container | `bool` | `false` | no |
| <a name="input_enable_traefik"></a> [enable\_traefik](#input\_enable\_traefik) | Whether to enable Traefik configuration via service tags | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | A map of environment variables to populate the task's environment before starting | `map(string)` | `{}` | no |
| <a name="input_group_volume_config"></a> [group\_volume\_config](#input\_group\_volume\_config) | Configuration for a group-level volume | <pre>object(<br/>    {<br/>      name            = string<br/>      type            = string<br/>      source          = string<br/>      read_only       = bool<br/>      access_mode     = string<br/>      attachment_mode = string<br/>      sticky          = bool<br/>      per_alloc       = bool<br/>      mount_options = object({<br/>        fs_type     = string<br/>        mount_flags = list(string)<br/>      })<br/>      destination = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the job should be placed | `string` | `""` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Network mode of the task | `string` | `""` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where the job should be placed | `string` | `"default"` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | A map of ports exposed by the task container | <pre>map(object(<br/>    {<br/>      static = optional(number)<br/>      to     = number<br/>    }<br/>  ))</pre> | <pre>{<br/>  "app": {<br/>    "to": 80<br/>  }<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the job should be placed | `string` | `""` | no |
| <a name="input_register_service"></a> [register\_service](#input\_register\_service) | Whether to register a Consul service for the job | `bool` | `true` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of job instances to deploy | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources to assign to the service task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      cores      = number<br/>      memory     = number<br/>      memory_max = number<br/>      secrets    = number<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_service_check"></a> [service\_check](#input\_service\_check) | Configuration of the service health check | <pre>object(<br/>    {<br/>      name     = string<br/>      type     = string<br/>      path     = string<br/>      method   = string<br/>      interval = string<br/>      timeout  = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_service_shutdown_delay"></a> [service\_shutdown\_delay](#input\_service\_shutdown\_delay) | Duration to wait when killing the task between removing its service registrations from Consul or Nomad, and sending it a shutdown signal | `string` | `"3s"` | no |
| <a name="input_service_tags"></a> [service\_tags](#input\_service\_tags) | A list of tags to applied to the Consul service | `list(string)` | `[]` | no |
| <a name="input_task_args"></a> [task\_args](#input\_task\_args) | A list of arguments to the optional `task_command`. If no command is specified, the arguments are passed directly to the container | `list(string)` | `[]` | no |
| <a name="input_task_command"></a> [task\_command](#input\_task\_command) | The command to run when starting the container | `string` | `""` | no |
| <a name="input_task_devices"></a> [task\_devices](#input\_task\_devices) | A list of devices to be exposed to the container | <pre>list(object(<br/>    {<br/>      host_path          = string<br/>      container_path     = optional(string)<br/>      cgroup_permissions = optional(string)<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_task_group_add"></a> [task\_group\_add](#input\_task\_group\_add) | A list of supplementary groups to be applied to the container user | `list(string)` | `[]` | no |
| <a name="input_task_kill_timeout"></a> [task\_kill\_timeout](#input\_task\_kill\_timeout) | Duration to wait for the container to gracefully quit before force-killing | `string` | `""` | no |
| <a name="input_task_nfs_volumes"></a> [task\_nfs\_volumes](#input\_task\_nfs\_volumes) | A list of task NFS volume mount configurations | <pre>list(object(<br/>    {<br/>      server   = string<br/>      path     = string<br/>      nfs_opts = string<br/>      target   = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_task_templates"></a> [task\_templates](#input\_task\_templates) | A list of template definitions to be configured for the task | <pre>list(object(<br/>    {<br/>      data        = string<br/>      destination = string<br/>      env         = bool<br/>      change_mode = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_task_templates_from_files"></a> [task\_templates\_from\_files](#input\_task\_templates\_from\_files) | A list of template definitions to be configured for the task using source files as data sources | <pre>list(object(<br/>    {<br/>      src_file    = string<br/>      destination = string<br/>      env         = bool<br/>      change_mode = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_task_user"></a> [task\_user](#input\_task\_user) | The user that will run the task | `string` | `""` | no |
| <a name="input_task_volumes"></a> [task\_volumes](#input\_task\_volumes) | A list of `host_path:container_path` strings to bind host paths to container paths | `list(string)` | `[]` | no |
| <a name="input_traefik_custom_http_headers"></a> [traefik\_custom\_http\_headers](#input\_traefik\_custom\_http\_headers) | A map of custom HTTP headers to apply to all service requests | `map(string)` | `{}` | no |
| <a name="input_traefik_entrypoints"></a> [traefik\_entrypoints](#input\_traefik\_entrypoints) | A list of Traefik endpoints to expose the service | `list(string)` | <pre>[<br/>  "web"<br/>]</pre> | no |
| <a name="input_traefik_route_custom_rules"></a> [traefik\_route\_custom\_rules](#input\_traefik\_route\_custom\_rules) | A list of custom rules to configure in the Traefik router | `list(string)` | `[]` | no |
| <a name="input_traefik_route_hosts"></a> [traefik\_route\_hosts](#input\_traefik\_route\_hosts) | A list of hostnames (e.g. `app.example.com`) to be used for exposing the service | `list(string)` | `[]` | no |
| <a name="input_traefik_route_path"></a> [traefik\_route\_path](#input\_traefik\_route\_path) | The path to be used for exposing the service (e.g. `/example`) | `string` | `""` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | Configuration for the job update strategy | <pre>object(<br/>    {<br/>      max_parallel      = number<br/>      min_healthy_time  = string<br/>      healthy_deadline  = string<br/>      progress_deadline = string<br/>      auto_revert       = bool<br/>      stagger           = string<br/>    }<br/>  )</pre> | `{}` | no |
<!-- END_TF_DOCS -->
