# ------------------------------------------------------------------------------
# GLOBAL/ENVIRONMENT
# ------------------------------------------------------------------------------

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["*"]
}

variable "node_pool" {
  description = "The node pool where the job should be placed"
  type        = string
  default     = "default"
}

variable "constraints" {
  description = "Service placement constraints"
  type = list(object(
    {
      attribute = string
      operator  = string
      value     = string
    }
  ))
  default = []
}

variable "namespace" {
  description = "The namespace where the job should be placed"
  type        = string
  default     = "default"
}

variable "traefik_entrypoint" {
  description = "Name of the Traefik entrypoint to configure the service in"
  type        = string
  default     = "web"
}

# ------------------------------------------------------------------------------
# APPLICATION
# ------------------------------------------------------------------------------

variable "job_name" {
  description = "The name to use as the job name"
  type        = string
}

variable "image" {
  description = "The container image name"
  type        = string
}

variable "port" {
  description = "The service port"
  type        = number
  default     = 8080
}

variable "replicas" {
  description = "The number of app instances to deploy"
  type        = number
  default     = 1
}

variable "env" {
  description = "A map of application environment variables"
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
  description = "Whether to register a service for the application job"
  type        = bool
  default     = true
}

variable "service_domain" {
  description = "Domain name of the service"
  type        = string
  default     = ""
}

variable "service_path" {
  description = "Path to expose the service"
  type        = string
  default     = ""
}

variable "health_check" {
  description = "Service health check configuration"
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

variable "service_custom_headers" {
  description = "A map representing a Traefik middleware HTTP header configuration to be applied to the service"
  type        = map(string)
  default     = {}
}

variable "service_tags" {
  description = "A list of extra tags for the service"
  type        = list(string)
  default     = []
}
