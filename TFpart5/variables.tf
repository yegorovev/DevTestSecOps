# --- aws ---
variable "region" {
  description = "AWS region"
  type        = string
  nullable    = false
  default     = "eu-central-1"
}

variable "default_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    Env     = "Test"
    Project = "Terraform"
  }
}

# --- ami ---
variable "ami" {
  description = "Filter ami image"
  type = object({
    name   = string
    values = string
    owners = string
  })
  nullable = false
}
# --- ami ---

# aws_key_pair
variable "key_name" {
  description = "Key pair"
  type        = string
  nullable    = false
}

# --- Module instance_profile---
variable "instance_profile" {
  description = "Instance profile configuration"
  type = object({
    role_name    = string
    profile_name = string
  })
  nullable = false
}

# --- Module sg ---
variable "application_sg" {
  description = "Custom security groups for application. cidr_blocks must be separated by a comma"
  type = list(object({
    sg_name = string
    vpc_id  = string
    rules   = list(map(string))
  }))
  default = []
}

# --- Module asg ---
variable "asg" {
  description = "Module asg configuration (aws_launch_configuration, aws_autoscaling_group)"
  type = object(
    {
      # aws_launch_configuration
      launch_config = object(
        {
          name          = string
          instance_type = string
        }
      )
      # aws_autoscaling_group
      asg_config = object(
        {
          name                = string
          min_size            = number
          max_size            = number
          desired_capacity    = number
          vpc_zone_identifier = list(string)
        }
      )
    }
  )
  nullable = false
}

# --- Module ecs ---
variable "ecs" {
  description = "Module ecs configuration (aws_ecs_cluster, aws_ecs_task_definition, aws_ecs_service)"
  type = object(
    {
      # aws_ecs_cluster
      ecs_name = string
      # aws_ecs_task_definition
      ecs_task_config = object(
        {
          name                     = string
          requires_compatibilities = list(string)
        }
      )
      # aws_ecs_service
      ecs_service_config = object(
        {
          name          = string
          desired_count = number
        }
      )
    }
  )
  nullable = false
}

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
