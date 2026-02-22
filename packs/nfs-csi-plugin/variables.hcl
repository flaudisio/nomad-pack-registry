# ------------------------------------------------------------------------------
# JOB PLACEMENT
# ------------------------------------------------------------------------------

variable "region" {
  description = "The region where jobs should be placed"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace where jobs should be placed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "node_pool" {
  description = "The node pool where jobs should be placed"
  type        = string
  default     = "default"
}

# ------------------------------------------------------------------------------
# GENERAL
# ------------------------------------------------------------------------------

variable "job_name_prefix" {
  description = "Prefix used in job names"
  type        = string
  default     = "nfs-csi-plugin"
}

# Ref: https://github.com/kubernetes-csi/csi-driver-nfs/blob/master/deploy/v4.13.1/csi-nfs-controller.yaml#L150
variable "image_name" {
  description = "Name of the plugin image"
  type        = string
  default     = "registry.k8s.io/sig-storage/nfsplugin"
}

variable "image_tag" {
  description = "Tag of the plugin image"
  type        = string
  default     = "v4.13.1"
}

variable "plugin_id" {
  description = "The plugin ID"
  type        = string
  default     = "nfs"
}

variable "controller_replicas" {
  description = "The number of controller instances to deploy"
  type        = number
  default     = 1
}

variable "controller_resources" {
  description = "Resources config for controller tasks"
  type = object(
    {
      cpu    = number
      memory = number
    }
  )
  default = {}
}

variable "node_resources" {
  description = "Resources config for node tasks"
  type = object(
    {
      cpu    = number
      memory = number
    }
  )
  default = {}
}
