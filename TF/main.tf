terraform {
  # VSC or terraform bug 
  # terraform init -backend-config=backend.hcl
  # Too many command line arguments. Did you mean to use -chdir?
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "1.1.9"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

data "aws_ami" "aws" {
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220406.1-x86_64-gp2"]
  }

  owners = ["137112412989"] # AWS
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter {
    name   = "default-for-az"
    values = [true]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

locals {
  default_rule = [
    { type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
  }]
}

locals {
  key_value         = file("../.ssh/ec2-key.pub")
  private_key_value = file("../.ssh/ec2-key")
}

resource "aws_key_pair" "ec2-key" {
  key_name   = "ec2-key"
  public_key = local.key_value
}

resource "aws_security_group_rule" "default_rules" {
  count = length(var.application_config) > 0 && length(var.application_sg) == 0 ? length(local.default_rule) : 0

  security_group_id = data.aws_security_group.default.id
  type              = local.default_rule[count.index].type
  from_port         = local.default_rule[count.index].from_port
  to_port           = local.default_rule[count.index].to_port
  protocol          = local.default_rule[count.index].protocol
  cidr_blocks       = split(",", local.default_rule[count.index].cidr_blocks)
}

module "sg" {
  count  = length(var.application_sg)
  source = "./modules/sg"

  sg_name = var.application_sg[count.index].sg_name
  vpc_id  = data.aws_vpc.default.id
  rules   = var.application_sg[count.index].rules
}

module "application" {
  count  = length(var.application_config)
  source = "./modules/vms/application"

  aws_ami_id             = data.aws_ami.aws.id
  key_name               = aws_key_pair.ec2-key.key_name
  subnet_id              = data.aws_subnet.default.id
  instance_name          = var.application_config[count.index].instance_name
  instance_type          = var.application_config[count.index].instance_type
  vpc_security_group_ids = module.sg[*].sg_id
  platform_details       = data.aws_ami.aws.platform_details
  account_id             = data.aws_caller_identity.current.account_id
  first_name             = var.first_name
  last_name              = var.last_name
  current_date           = var.current_date
  private_key_value      = local.private_key_value
  hello_file_remote_path = var.hello_file_remote_path
}

resource "null_resource" "out" {
  triggers = {
    instance_ids = "${join(",", module.application.*.application_id)}"
  }

  count = length(module.application)
  provisioner "remote-exec" {
    inline = [
      join(" ", ["hostname;", "cat", var.hello_file_remote_path])
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = module.application[count.index].public_ip
      private_key = local.private_key_value
    }
  }
}
