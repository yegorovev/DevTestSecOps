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

variable "application_config" {
  description = "Custom application instance attributes"
  type = list(object({
    instance_name = string
  }))
  default = []
}

variable "application_sg" {
  description = "Custom security groups for application. cidr_blocks must be separated by a comma"
  type = list(object({
    sg_name       = string
    vpc_id        = string
    rules = list(map(string))
  }))
  default = []
}

variable "first_name" {
  type    = string
  default = "Ivan"
}

variable "last_name" {
  type    = string
  default = "Maria"
}

variable "current_date" {
  type    = string
  default = "27/04/2020"
}
