<!-- BEGIN_PACK_METADATA -->
# webapp

This pack runs a single system job that can be accessed via HTTP.
<!-- END_PACK_METADATA -->

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image"></a> [image](#input\_image) | The container image name | `string` | n/a | yes |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | The name to use as the job name | `string` | n/a | yes |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | Service placement constraints | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | A map of application environment variables | `map(string)` | `{}` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Service health check configuration | <pre>object(<br/>    {<br/>      name     = string<br/>      type     = string<br/>      path     = string<br/>      method   = string<br/>      interval = string<br/>      timeout  = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the job should be placed | `string` | `"default"` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where the job should be placed | `string` | `"default"` | no |
| <a name="input_port"></a> [port](#input\_port) | The service port | `number` | `8080` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where jobs will be deployed | `string` | `""` | no |
| <a name="input_register_service"></a> [register\_service](#input\_register\_service) | Whether to register a service for the application job | `bool` | `true` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of app instances to deploy | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources to assign to the service task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      cores      = number<br/>      memory     = number<br/>      memory_max = number<br/>      secrets    = number<br/>    }<br/>  )</pre> | <pre>{<br/>  "cores": null,<br/>  "cpu": 100,<br/>  "memory": 128,<br/>  "memory_max": null,<br/>  "secrets": null<br/>}</pre> | no |
| <a name="input_service_custom_headers"></a> [service\_custom\_headers](#input\_service\_custom\_headers) | A map representing a Traefik middleware HTTP header configuration to be applied to the service | `map(string)` | `{}` | no |
| <a name="input_service_domain"></a> [service\_domain](#input\_service\_domain) | Domain name of the service | `string` | `""` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to expose the service | `string` | `""` | no |
| <a name="input_service_tags"></a> [service\_tags](#input\_service\_tags) | A list of extra tags for the service | `list(string)` | `[]` | no |
| <a name="input_traefik_entrypoint"></a> [traefik\_entrypoint](#input\_traefik\_entrypoint) | Name of the Traefik entrypoint to configure the service in | `string` | `"web"` | no |
<!-- END_TF_DOCS -->
