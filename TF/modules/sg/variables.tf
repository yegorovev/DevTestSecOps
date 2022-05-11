variable "vpc_id" {
  description = "ID aws vpc"
  type        = string
  nullable    = false
}

variable "sg_name" {
  description = "Name for security group"
  nullable    = false
  default     = ""
}

variable "rules" {
  description = "Ingress and egress security group rules. cidr_blocks must be separated by a comma"
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
  }))
  default = []
}
