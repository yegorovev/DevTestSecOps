variable "ecs_name" {
  description = "Cluster name"
  type        = string
  nullable    = false
}


variable "ecs_task_config" {
  description = "Task configuration"
  type = object({
    name                     = string
    requires_compatibilities = list(string)
  })
  nullable = false
}

variable "ecs_service_config" {
  description = "Service configuration"
  type = object({
    name          = string
    desired_count = number
  })
  nullable = false
}

# --- container ---
variable "ecs_container_config" {
  description = "Container configuration"
  type = object(
    {
      name   = string
      image  = string
      cpu    = number
      memory = number
      port_mappings = list(object(
        {
          hostPort      = number
          containerPort = number
          protocol      = string
        }
      ))
      command = list(string)
    }
  )
  nullable = false
}
