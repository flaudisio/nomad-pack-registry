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
|------|-------------|------|---------|:--------:|
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The container image name | `string` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The container image tag | `string` | n/a | yes |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | The name of the job | `string` | n/a | yes |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | A list of constraints for restricting the set of eligible nodes to place the job | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_consul_service_check"></a> [consul\_service\_check](#input\_consul\_service\_check) | Configuration of the service health check | <pre>object(<br/>    {<br/>      name     = string<br/>      type     = string<br/>      path     = string<br/>      method   = string<br/>      interval = string<br/>      timeout  = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_consul_service_tags"></a> [consul\_service\_tags](#input\_consul\_service\_tags) | A list of extra tags applied to the service | `list(string)` | `[]` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "dc1"<br/>]</pre> | no |
| <a name="input_enable_nomad_secrets"></a> [enable\_nomad\_secrets](#input\_enable\_nomad\_secrets) | Whether all Nomad secrets readable by the job should be loaded and exposed as environment variables to the container | `bool` | `false` | no |
| <a name="input_enable_traefik"></a> [enable\_traefik](#input\_enable\_traefik) | Whether to enable Traefik configuration via service tags | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | A map of environment variables to be configured in the task container | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the job should be placed | `string` | `""` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where the job should be placed | `string` | `"default"` | no |
| <a name="input_port"></a> [port](#input\_port) | The port exposed by the task container | `number` | `80` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the job should be placed | `string` | `""` | no |
| <a name="input_register_consul_service"></a> [register\_consul\_service](#input\_register\_consul\_service) | Whether to register a Consul service for the job | `bool` | `true` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of job instances to deploy | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources to assign to the service task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      cores      = number<br/>      memory     = number<br/>      memory_max = number<br/>      secrets    = number<br/>    }<br/>  )</pre> | <pre>{<br/>  "cores": null,<br/>  "cpu": 100,<br/>  "memory": 128,<br/>  "memory_max": null,<br/>  "secrets": null<br/>}</pre> | no |
| <a name="input_traefik_entrypoints"></a> [traefik\_entrypoints](#input\_traefik\_entrypoints) | A list of Traefik endpoints to expose the service | `list(string)` | <pre>[<br/>  "web"<br/>]</pre> | no |
| <a name="input_traefik_http_headers"></a> [traefik\_http\_headers](#input\_traefik\_http\_headers) | A map of HTTP headers to be configured for the service | `map(string)` | `{}` | no |
| <a name="input_traefik_route_host"></a> [traefik\_route\_host](#input\_traefik\_route\_host) | The hostname to be used for exposing the service (e.g. `app.example.com`) | `string` | `""` | no |
| <a name="input_traefik_route_path"></a> [traefik\_route\_path](#input\_traefik\_route\_path) | The path to be used for exposing the service (e.g. `/example`) | `string` | `""` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | Configuration for the job update strategy | <pre>object(<br/>    {<br/>      max_parallel      = number<br/>      min_healthy_time  = string<br/>      healthy_deadline  = string<br/>      progress_deadline = string<br/>      auto_revert       = bool<br/>      stagger           = string<br/>    }<br/>  )</pre> | <pre>{<br/>  "auto_revert": false,<br/>  "healthy_deadline": "5m",<br/>  "max_parallel": 1,<br/>  "min_healthy_time": "10s",<br/>  "progress_deadline": "10m",<br/>  "stagger": "30s"<br/>}</pre> | no |
<!-- END_TF_DOCS -->
