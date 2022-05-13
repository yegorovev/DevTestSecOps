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

locals {
  key_value = file("../.ssh/ec2-key.pub")
}

data "aws_ami" "ami" {
  filter {
    name   = var.ami.name
    values = [var.ami.values]
  }
  owners = [var.ami.owners]
}

resource "aws_key_pair" "ec2-key" {
  key_name   = var.key_name
  public_key = local.key_value
}

module "sg" {
  count   = length(var.application_sg)
  source  = "./modules/sg"
  sg_name = var.application_sg[count.index].sg_name
  vpc_id  = var.application_sg[count.index].vpc_id
  rules   = var.application_sg[count.index].rules
}

module "instance_profile" {
  source       = "./modules/instance_profile"
  role_name    = var.instance_profile.role_name
  profile_name = var.instance_profile.profile_name
}

locals {
  # Enrichment var launch_config (asg modue)
  launch_config = {
    name                 = var.asg.launch_config.name
    image_id             = data.aws_ami.ami.id
    instance_type        = var.asg.launch_config.instance_type
    key_name             = var.key_name
    security_groups      = module.sg[*].sg_id
    iam_instance_profile = module.instance_profile.instance_profile_name
    user_data            = templatefile("./files/ecs_init.sh", { cluster_name = var.ecs.ecs_name })
  }
}

module "asg" {
  source        = "./modules/asg"
  launch_config = local.launch_config
  asg_config    = var.asg.asg_config
}


module "ecs" {
  source               = "./modules/ecs"
  ecs_name             = var.ecs.ecs_name
  ecs_task_config      = var.ecs.ecs_task_config
  ecs_service_config   = var.ecs.ecs_service_config
  ecs_container_config = var.ecs_container_config
}
