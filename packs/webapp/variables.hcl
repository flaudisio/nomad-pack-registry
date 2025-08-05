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

variable "replicas" {
  description = "The number of app instances to deploy"
  type        = number
  default     = 1
}

variable "env" {
  description = "A map of environment variables to be configured in the task container"
  type        = map(string)
  default     = {}
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

variable "register_service" {
  description = "Whether to register a service for the job"
  type        = bool
  default     = true
}

variable "traefik_entrypoint" {
  description = "Name of the Traefik entrypoint to configure the service in"
  type        = string
  default     = "web"
}

variable "service_host" {
  description = "The hostname to be used for exposing the service (e.g. `app.example.com`)"
  type        = string
  default     = ""
}

variable "service_path" {
  description = "The path to be used for exposing the service (e.g. `/example`)"
  type        = string
  default     = ""
}

variable "service_http_headers" {
  description = "A map of HTTP headers to be configured for the service"
  type        = map(string)
  default     = {}
}

variable "service_extra_tags" {
  description = "A list of extra tags applied to the service"
  type        = list(string)
  default     = []
}

variable "health_check" {
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
