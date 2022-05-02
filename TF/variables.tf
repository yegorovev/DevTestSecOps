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

variable "ext_ip" {
  type    = string
  default = "0.0.0.0/0"
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
