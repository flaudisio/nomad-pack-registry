# ------------------------------------------------------------------------------
# JOB PLACEMENT
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
  default     = "n8n"
}

variable "replicas" {
  description = "The number of job instances to deploy"
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
  default = {}
}

variable "image_name" {
  description = "The container image name"
  type        = string
  default     = "docker.n8n.io/n8nio/n8n"
}

variable "image_tag" {
  description = "The container image tag"
  type        = string
  default     = "latest"
}

variable "static_port" {
  description = "Static HTTP port"
  type        = number
  default     = -1
}

variable "env" {
  description = "A map of environment variables to populate the task's environment before starting"
  type        = map(string)
  default     = {}
}

variable "timezone" {
  description = "Timezone to be configured in the containers"
  type        = string
  default     = "UTC"
}

variable "app_resources" {
  description = "Resources to assign to the application task that runs on every client"
  type = object(
    {
      cpu        = number
      memory     = number
      memory_max = number
    }
  )
  default = {}
}

variable "app_group_volume_config" {
  description = "Group-level volume configuration for the application container"
  type = object(
    {
      name            = string
      type            = string
      source          = string
      access_mode     = string
      attachment_mode = string
    }
  )
  default = {}
}

variable "app_task_nfs_volume_config" {
  description = "Configuration for mounting an NFS volume for the application task"
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
  description = "The hostname to be used for exposing the service (e.g. `n8n.example.com`)"
  type        = string
  default     = ""
}

variable "traefik_route_path" {
  description = "The path to be used for exposing the service (e.g. `/example`)"
  type        = string
  default     = ""
}

variable "traefik_custom_http_headers" {
  description = "A map of custom HTTP headers to apply to all service requests"
  type        = map(string)
  default     = {}
}

variable "consul_service_tags" {
  description = "A list of tags to applied to the Consul service"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------
# POSTGRES
# ------------------------------------------------------------------------------

variable "postgres_image_name" {
  description = "The Postgres image name"
  type        = string
  default     = "postgres"
}

variable "postgres_image_tag" {
  description = "The Postgres image tag"
  type        = string
  default     = "16-alpine"
}

variable "postgres_resources" {
  description = "Resources to assign to the Postgres task that runs on every client"
  type = object(
    {
      cpu        = number
      memory     = number
      memory_max = number
    }
  )
  default = {}
}

variable "postgres_db_name" {
  description = "The Postgres database name"
  type        = string
  default     = "n8n"
}

variable "postgres_db_user" {
  description = "The Postgres database user"
  type        = string
  default     = "n8n"
}

variable "postgres_group_volume_config" {
  description = "Group-level volume configuration for the Postgres container"
  type = object(
    {
      name            = string
      type            = string
      source          = string
      access_mode     = string
      attachment_mode = string
    }
  )
  default = {}
}

variable "postgres_task_nfs_volume_config" {
  description = "Configuration for mounting an NFS volume for the Postgres task"
  type = object(
    {
      server   = string
      path     = string
      nfs_opts = string
    }
  )
  default = {}
}
