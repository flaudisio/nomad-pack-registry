# ------------------------------------------------------------------------------
# GLOBAL/ENVIRONMENT
# ------------------------------------------------------------------------------

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "node_pool" {
  description = "The node pool where the job should be placed"
  type        = string
  default     = "default"
}

variable "region" {
  description = "The region where the job should be placed"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace where the job should be placed"
  type        = string
  default     = ""
}

variable "constraints" {
  description = "A list of constraints for restricting the set of eligible nodes to place the job"
  type = list(object(
    {
      attribute = string
      operator  = string
      value     = string
    }
  ))
  default = []
}

# ------------------------------------------------------------------------------
# APPLICATION
# ------------------------------------------------------------------------------

variable "job_name" {
  description = "The name of the job"
  type        = string
  default     = "syncthing"
}

variable "replicas" {
  description = "The number of Syncthing instances to deploy"
  type        = number
  default     = 1
}

variable "update_strategy" {
  description = "Configuration for the job update strategy"
  type = object(
    {
      max_parallel      = number
      min_healthy_time  = string
      healthy_deadline  = string
      progress_deadline = string
      auto_revert       = bool
      stagger           = string
    }
  )
  default = {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = false
    stagger           = "30s"
  }
}

variable "replicas" {
  description = "The number of job instances to deploy"
  type        = number
  default     = 1
}

variable "image_name" {
  description = "The container image name"
  type        = string
  default     = "syncthing/syncthing"
}

variable "image_tag" {
  description = "The container image tag"
  type        = string
  default     = "latest"
}

variable "env" {
  description = "A map of environment variables to be exposed to the container"
  type        = map(string)
  default     = {}
}

variable "enable_nomad_variables" {
  description = "Whether all Nomad variables readable by the job should be loaded and exposed as environment variables in the container"
  type        = bool
  default     = false
}

variable "network_mode" {
  description = "Mode of the group network"
  type        = string
  default     = "host"
}

variable "webgui_port" {
  description = "The HTTP port for Syncthing Web GUI"
  type        = number
  default     = 8384
}

variable "sync_protocol_port" {
  description = "The TCP port for Syncthing Web GUI"
  type        = number
  default     = 22000
}

variable "resources" {
  description = "Resources to assign to the service task that runs on every client"
  type = object(
    {
      cpu        = number
      cores      = number
      memory     = number
      memory_max = number
      secrets    = number
    }
  )
  default = {
    cpu        = 100
    cores      = null
    memory     = 256
    memory_max = null
    secrets    = null
  }
}

variable "ephemeral_disk" {
  description = "Configuration of the group's ephemeral disk"
  type = object(
    {
      migrate = bool
      size    = number
      sticky  = bool
    }
  )
  default = {
    migrate = true
    size    = 1000
    sticky  = true
  }
}

variable "container_data_dir" {
  description = "The Syncthing data directory path inside the container"
  type        = string
  default     = "/var/syncthing"
}

variable "group_volume_config" {
  description = "Configuration for a group-level volume"
  type = object(
    {
      name   = string
      type   = string
      source = string
    }
  )
  default = {}
}

variable "task_nfs_volume_config" {
  description = "Configuration for mounting an NFS volume at task-level"
  type = object(
    {
      server   = string
      path     = string
      nfs_opts = string
    }
  )
  default = {}
}

# ------------------------------------------------------------------------------
# SERVICE
# ------------------------------------------------------------------------------

variable "register_consul_service" {
  description = "Whether to register a Consul service for the job"
  type        = bool
  default     = true
}

variable "enable_traefik" {
  description = "Whether to enable Traefik configuration via service tags"
  type        = bool
  default     = false
}

variable "traefik_entrypoints" {
  description = "A list of Traefik endpoints to expose the service"
  type        = list(string)
  default     = ["web"]
}

variable "traefik_route_host" {
  description = "The Traefik router host"
  type        = string
  default     = ""
}

variable "traefik_route_path" {
  description = "The Traefik router patht"
  type        = string
  default     = ""
}

variable "traefik_http_headers" {
  description = "Map of HTTP headers to be passed by to the service"
  type        = map(string)
  default     = {}
}

variable "consul_service_tags" {
  description = "A list of tags to applied to the Consul service"
  type        = list(string)
  default     = []
}
