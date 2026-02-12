<!-- BEGIN_PACK_METADATA -->
# syncthing

Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.
<!-- END_PACK_METADATA -->

## How to use this pack?

- See the [repository README](../../README.md) for instructions on how to use packs.
- See the [examples](../../examples) folder for sample usage.
- See [variables.hcl](variables.hcl) for all the variables supported by this pack.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_constraints"></a> [constraints](#input\_constraints) | A list of constraints for restricting the set of eligible nodes to place the job | <pre>list(object(<br/>    {<br/>      attribute = string<br/>      operator  = string<br/>      value     = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_consul_service_tags"></a> [consul\_service\_tags](#input\_consul\_service\_tags) | A list of tags to applied to the Consul service | `list(string)` | `[]` | no |
| <a name="input_container_data_dir"></a> [container\_data\_dir](#input\_container\_data\_dir) | The Syncthing data directory path inside the container | `string` | `"/var/syncthing"` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "dc1"<br/>]</pre> | no |
| <a name="input_enable_traefik"></a> [enable\_traefik](#input\_enable\_traefik) | Whether to enable Traefik configuration via service tags | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | A map of environment variables to populate the task's environment before starting | `map(string)` | `{}` | no |
| <a name="input_ephemeral_disk"></a> [ephemeral\_disk](#input\_ephemeral\_disk) | Configuration of the group's ephemeral disk | <pre>object(<br/>    {<br/>      migrate = bool<br/>      size    = number<br/>      sticky  = bool<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_group_volume_config"></a> [group\_volume\_config](#input\_group\_volume\_config) | Configuration for a group-level volume | <pre>object(<br/>    {<br/>      name            = string<br/>      type            = string<br/>      source          = string<br/>      access_mode     = string<br/>      attachment_mode = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The container image name | `string` | `"syncthing/syncthing"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The container image tag | `string` | `"latest"` | no |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | The name of the job | `string` | `"syncthing"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the job should be placed | `string` | `""` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Network mode of the Syncthing task | `string` | `"host"` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where the job should be placed | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the job should be placed | `string` | `""` | no |
| <a name="input_register_consul_service"></a> [register\_consul\_service](#input\_register\_consul\_service) | Whether to register a Consul service for the job | `bool` | `true` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of job instances to deploy | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources to assign to the task | <pre>object(<br/>    {<br/>      cpu        = number<br/>      cores      = number<br/>      memory     = number<br/>      memory_max = number<br/>      secrets    = number<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_sync_protocol_port"></a> [sync\_protocol\_port](#input\_sync\_protocol\_port) | The TCP port for Syncthing Web GUI | `number` | `22000` | no |
| <a name="input_task_nfs_volume_config"></a> [task\_nfs\_volume\_config](#input\_task\_nfs\_volume\_config) | Configuration for mounting an NFS volume at task-level | <pre>object(<br/>    {<br/>      server   = string<br/>      path     = string<br/>      nfs_opts = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_traefik_custom_http_headers"></a> [traefik\_custom\_http\_headers](#input\_traefik\_custom\_http\_headers) | A map of custom HTTP headers to apply to all service requests | `map(string)` | `{}` | no |
| <a name="input_traefik_entrypoints"></a> [traefik\_entrypoints](#input\_traefik\_entrypoints) | A list of Traefik endpoints to expose the service | `list(string)` | <pre>[<br/>  "web"<br/>]</pre> | no |
| <a name="input_traefik_route_hosts"></a> [traefik\_route\_hosts](#input\_traefik\_route\_hosts) | A list of hostnames (e.g. `app.example.com`) to be used for exposing the service | `list(string)` | `[]` | no |
| <a name="input_traefik_route_path"></a> [traefik\_route\_path](#input\_traefik\_route\_path) | The path to be used for exposing the service (e.g. `/example`) | `string` | `""` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | Configuration for the job update strategy | <pre>object(<br/>    {<br/>      max_parallel      = number<br/>      min_healthy_time  = string<br/>      healthy_deadline  = string<br/>      progress_deadline = string<br/>      auto_revert       = bool<br/>      stagger           = string<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_webgui_port"></a> [webgui\_port](#input\_webgui\_port) | The HTTP port for Syncthing Web GUI | `number` | `8384` | no |
<!-- END_TF_DOCS -->
