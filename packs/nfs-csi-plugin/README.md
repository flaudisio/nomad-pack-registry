<!-- BEGIN_PACK_METADATA -->
# nfs-csi-plugin

The Container Storage Interface (CSI) plugin for Network File System (NFS) enables the dynamic
provisioning and management of NFS volumes for containerized workloads.
<!-- END_PACK_METADATA -->

## Prerequisites

In order to deploy the NFS CSI plugin, make sure you have the following prerequisites in place:

1. Nomad 1.3.0 or above.
1. Enable privileged Docker jobs: CSI Node plugins must run as privileged Docker jobs because they use
   bidirectional mount propagation in order to mount disks to the underlying host.
   1. Edit the configuration for all Nomad clients and set [allow_privileged](https://developer.hashicorp.com/nomad/docs/deploy/task-driver/docker#allow_privileged)
      to `true` inside of the Docker plugin's configuration. Restart the Nomad client process to load
      this new configuration.

For details, see [Nomad: NFS CSI Volume](https://support.hashicorp.com/hc/en-us/articles/22557185128083-Nomad-NFS-CSI-Volume).

## How to use this pack?

- See the [repository README](../../README.md) for instructions on how to use packs.
- See the [examples](../../examples) folder for sample usage.
- See [variables.hcl](variables.hcl) for all the variables supported by this pack.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_controller_replicas"></a> [controller\_replicas](#input\_controller\_replicas) | The number of controller instances to deploy | `number` | `1` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources config for controller tasks | <pre>object(<br/>    {<br/>      cpu    = number<br/>      memory = number<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_datacenters"></a> [datacenters](#input\_datacenters) | A list of datacenters in the region which are eligible for task placement | `list(string)` | <pre>[<br/>  "dc1"<br/>]</pre> | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name of the plugin image | `string` | `"registry.k8s.io/sig-storage/nfsplugin"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Tag of the plugin image | `string` | `"v4.13.1"` | no |
| <a name="input_job_name_prefix"></a> [job\_name\_prefix](#input\_job\_name\_prefix) | Prefix used in job names | `string` | `"nfs-csi-plugin"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where jobs should be placed | `string` | `""` | no |
| <a name="input_node_pool"></a> [node\_pool](#input\_node\_pool) | The node pool where jobs should be placed | `string` | `"default"` | no |
| <a name="input_node_resources"></a> [node\_resources](#input\_node\_resources) | Resources config for node tasks | <pre>object(<br/>    {<br/>      cpu    = number<br/>      memory = number<br/>    }<br/>  )</pre> | `{}` | no |
| <a name="input_plugin_id"></a> [plugin\_id](#input\_plugin\_id) | The plugin ID | `string` | `"nfs"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where jobs should be placed | `string` | `""` | no |
<!-- END_TF_DOCS -->
