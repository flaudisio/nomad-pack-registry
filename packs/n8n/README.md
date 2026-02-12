<!-- BEGIN_PACK_METADATA -->
# n8n

n8n is a workflow automation platform that gives technical teams the flexibility of code with the speed of no-code.
<!-- END_PACK_METADATA -->

## Prerequisites

Before deploying this pack, make sure to:

1. Configure Nomad integration with Consul (used for service discovery)
1. Create the required Nomad variable:

    ```sh
    nomad var put 'nomad/jobs/<JOB_NAME>' \
        N8N_ENCRYPTION_KEY='ExampleEncryptionKey' \
        POSTGRES_PASSWORD='ExamplePassword'
    ```

## How to use this pack?

- See the [repository README](../../README.md) for instructions on how to use packs.
- See the [examples](../../examples) folder for sample usage.
- See [variables.hcl](variables.hcl) for all the variables supported by this pack.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_group_volume_config"></a> [app\_group\_volume\_config](#input\_app\_group\_volume\_config) | Group-level volume configuration for the application container | <pre>object(<br/>    {<br/>      name            = string<br/>      type            = string<br/>      source          = string<br/>      access_mode     = string<br/>      attachment_mode = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_app_resources"></a> [app\_resources](#input\_app\_resources) | Resources to assign to the application task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      memory     = number<br/>      memory_max = number<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_app_task_nfs_volume_config"></a> [app\_task\_nfs\_volume\_config](#input\_app\_task\_nfs\_volume\_config) | Configuration for mounting an NFS volume for the application task | <pre>object(<br/>    {<br/>      server   = string<br/>      path     = string<br/>      nfs_opts = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | A list of constraints for restricting the set of eligible nodes to place the job | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_consul_service_tags"></a> [consul\_service\_tags](#input\_consul\_service\_tags) | A list of tags to applied to the Consul service | `list(string)` | `[]` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "dc1"<br/>]</pre> | no |
| <a name="input_enable_traefik"></a> [enable\_traefik](#input\_enable\_traefik) | Whether to enable Traefik configuration via service tags | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | A map of environment variables to populate the task's environment before starting | `map(string)` | `{}` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The application image name | `string` | `"docker.n8n.io/n8nio/n8n"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The application image tag | `string` | `"latest"` | no |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | The name of the job | `string` | `"n8n"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the job should be placed | `string` | `""` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where the job should be placed | `string` | `"default"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | The Postgres database name | `string` | `"n8n"` | no |
| <a name="input_postgres_db_user"></a> [postgres\_db\_user](#input\_postgres\_db\_user) | The Postgres database user | `string` | `"n8n"` | no |
| <a name="input_postgres_group_volume_config"></a> [postgres\_group\_volume\_config](#input\_postgres\_group\_volume\_config) | Group-level volume configuration for the Postgres container | <pre>object(<br/>    {<br/>      name            = string<br/>      type            = string<br/>      source          = string<br/>      access_mode     = string<br/>      attachment_mode = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_postgres_image_name"></a> [postgres\_image\_name](#input\_postgres\_image\_name) | The Postgres image name | `string` | `"postgres"` | no |
| <a name="input_postgres_image_tag"></a> [postgres\_image\_tag](#input\_postgres\_image\_tag) | The Postgres image tag | `string` | `"16-alpine"` | no |
| <a name="input_postgres_resources"></a> [postgres\_resources](#input\_postgres\_resources) | Resources to assign to the Postgres task that runs on every client | <pre>object(<br/>    {<br/>      cpu        = number<br/>      memory     = number<br/>      memory_max = number<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_postgres_task_nfs_volume_config"></a> [postgres\_task\_nfs\_volume\_config](#input\_postgres\_task\_nfs\_volume\_config) | Configuration for mounting an NFS volume for the Postgres task | <pre>object(<br/>    {<br/>      server   = string<br/>      path     = string<br/>      nfs_opts = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the job should be placed | `string` | `""` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of job instances to deploy | `number` | `1` | no |
| <a name="input_static_port"></a> [static\_port](#input\_static\_port) | Static HTTP port | `number` | `-1` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone to be configured in the containers | `string` | `"UTC"` | no |
| <a name="input_traefik_custom_http_headers"></a> [traefik\_custom\_http\_headers](#input\_traefik\_custom\_http\_headers) | A map of custom HTTP headers to apply to all service requests | `map(string)` | `{}` | no |
| <a name="input_traefik_entrypoints"></a> [traefik\_entrypoints](#input\_traefik\_entrypoints) | A list of Traefik endpoints to expose the service | `list(string)` | <pre>[<br/>  "web"<br/>]</pre> | no |
| <a name="input_traefik_route_hosts"></a> [traefik\_route\_hosts](#input\_traefik\_route\_hosts) | A list of hostnames (e.g. `app.example.com`) to be used for exposing the service | `list(string)` | `[]` | no |
| <a name="input_traefik_route_path"></a> [traefik\_route\_path](#input\_traefik\_route\_path) | The path to be used for exposing the service (e.g. `/example`) | `string` | `""` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | Configuration for the job update strategy | <pre>object(<br/>    {<br/>      max_parallel      = number<br/>      min_healthy_time  = string<br/>      healthy_deadline  = string<br/>      progress_deadline = string<br/>      auto_revert       = bool<br/>      stagger           = string<br/>    }<br/>  )</pre> | `{}` | no |
<!-- END_TF_DOCS -->
