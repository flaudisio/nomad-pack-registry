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
}

variable "image_tag" {
  description = "The container image tag"
  type        = string
}

variable "port" {
  description = "The port exposed by the task container"
  type        = number
  default     = 80
}

variable "static_port" {
  description = "Static port to be mapped to `port`"
  type        = number
  default     = -1
}

variable "env" {
  description = "A map of environment variables to populate the task's environment before starting"
  type        = map(string)
  default     = {}
}

variable "enable_nomad_secrets" {
  description = "Whether all Nomad secrets readable by the job should be loaded and exposed as environment variables to the container"
  type        = bool
  default     = false
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
    memory     = 128
    memory_max = null
    secrets    = null
  }
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
  description = "The hostname to be used for exposing the service (e.g. `app.example.com`)"
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
  description = "A list of extra tags applied to the service"
  type        = list(string)
  default     = []
}

variable "consul_service_check" {
  description = "Configuration of the service health check"
  type = object(
    {
      name     = string
      type     = string
      path     = string
      method   = string
      interval = string
      timeout  = string
    }
  )
  default = {}
}
