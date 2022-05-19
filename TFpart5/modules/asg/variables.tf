variable "launch_config" {
  description = "Launch configuration"
  type = object({
    name                 = string
    image_id             = string
    instance_type        = string
    key_name             = string
    security_groups      = list(string)
    iam_instance_profile = string
    user_data            = string
  })
  nullable = false
}

variable "asg_config" {
  description = "Autoscaling group configuration"
  type = object({
    name                = string
    min_size            = number
    max_size            = number
    desired_capacity    = number
    vpc_zone_identifier = list(string)
  })
  nullable = false
}
