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

variable "periodic" {
  description = "Periodic block configuration"
  type = object({
    enabled          = bool
    crons            = list(string)
    time_zone        = string
    prohibit_overlap = bool
  })
}

variable "restart" {
  description = "Restart block configuration"
  type = object({
    attempts         = number
    delay            = string
    interval         = string
    mode             = string
    render_templates = bool
  })
  default = {}
}

variable "replicas" {
  description = "The number of job instances to deploy"
  type        = number
  default     = 1
}

variable "image_name" {
  description = "The container image name"
  type        = string
}

variable "image_tag" {
  description = "The container image tag"
  type        = string
}

variable "image_force_pull" {
  description = "Whether to always pull the most recent image instead of using existing local image"
  type        = bool
  default     = true
}

variable "task_command" {
  description = "The command to run when starting the container"
  type        = string
  default     = ""
}

variable "task_args" {
  description = "A list of arguments to the optional `task_command`"
  type        = list(string)
  default     = []
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
  default = {}
}
