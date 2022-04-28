variable "aws_ami_id" {
  description = "ID of the EC2 AWS image instance t2.micro"
  type    = string
  nullable = false
}

variable "key_name" {
  description = "A name of aws_key_pair"
  type    = string
  nullable = false
}

variable "subnet_id" {
  description = "ID of the VPC subnet"
  type    = string
  nullable = false
}

variable "vpc_security_group_ids" {
  description = "A security group set"
  type    = list(string)
  nullable = false
}

variable "platform_details" {
  description = "A value for OS_type tag"
  type    = string
  nullable = false
}

variable "account_id" {
  description = "A value for AWS_Account_ID tag"
  type    = string
  nullable = false
}

variable "first_name" {
  description = "A value for First_Name tag"
  type    = string
  default = "Ivan"
  nullable = false
}

variable "last_name" {
  description = "A value for Last_Name tag"
  type    = string
  default = "Maria"
  nullable = false
}

variable "current_date" {
  description = "A value for Date_creation tag"
  type    = string
  default = "27/04/2020"
  nullable = false
}

variable "private_key_value" {
  description = "A value of a private key"
  type    = string
  nullable = false
  sensitive = true
}