terraform {
  backend "s3" {
    bucket         = "terraform-state-ev-20220101"
    key            = "Test/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform_state_locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "1.1.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
  default_tags {
    tags = {
      Env     = "Test"
      Project = "Terraform"
    }
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

locals {
  key_value = file("../.ssh/ec2-key.pub")
  private_key_value = file("../.ssh/ec2-key")
}

resource "aws_security_group" "sg_apache" {
  name   = "sg_apache"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ext_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ext_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ec2-key" {
  key_name   = "ec2-key"
  public_key = local.key_value
}

module "DevTestSecOps" {
  source = "./modules/VMs/Test"

  aws_ami_id             = data.aws_ami.aws.id
  key_name               = aws_key_pair.ec2-key.key_name
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.sg_apache.id]
  platform_details       = data.aws_ami.aws.platform_details
  account_id             = data.aws_caller_identity.current.account_id
  first_name             = var.first_name
  last_name              = var.last_name
  current_date           = var.current_date
  private_key_value      = local.private_key_value
}
