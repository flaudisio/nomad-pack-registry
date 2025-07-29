# webapp

This pack runs a single system job that can be accessed via HTTP.

## Dependencies

None.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image"></a> [image](#input\_image) | The container image name | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The service name for the application | `string` | n/a | yes |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | Service placement constraints | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | A map of application environment variables | `map(string)` | `{}` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Service health check configuration | <pre>object(<br/>    {<br/>      name     = string<br/>      type     = string<br/>      path     = string<br/>      method   = string<br/>      interval = string<br/>      timeout  = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_port"></a> [port](#input\_port) | The service port | `number` | `8080` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where jobs will be deployed | `string` | `""` | no |
| <a name="input_register_service"></a> [register\_service](#input\_register\_service) | Whether to register a service for the application job | `bool` | `true` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of app instances to deploy | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources to assign to the service task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      cores      = number<br/>      memory     = number<br/>      memory_max = number<br/>      secrets    = number<br/>    }<br/>  )</pre> | <pre>{<br/>  "cores": null,<br/>  "cpu": 100,<br/>  "memory": 128,<br/>  "memory_max": null,<br/>  "secrets": null<br/>}</pre> | no |
| <a name="input_service_basedomain"></a> [service\_basedomain](#input\_service\_basedomain) | Default base domain to be used when a custom service domain is not specified | `string` | `"flaudisio.com"` | no |
| <a name="input_service_custom_headers"></a> [service\_custom\_headers](#input\_service\_custom\_headers) | A map representing a Traefik middleware HTTP header configuration to be applied to the service | `map(string)` | `{}` | no |
| <a name="input_service_domain"></a> [service\_domain](#input\_service\_domain) | Domain name of the service | `string` | `""` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to expose the service | `string` | `""` | no |
| <a name="input_service_tags"></a> [service\_tags](#input\_service\_tags) | A list of extra tags for the service | `list(string)` | `[]` | no |
<!-- END_TF_DOCS -->
