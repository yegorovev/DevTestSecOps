terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "1.1.9"
}

resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "rules" {
  count             = length(var.rules)
  
  security_group_id = aws_security_group.sg.id
  type              = var.rules[count.index].type
  from_port         = var.rules[count.index].from_port
  to_port           = var.rules[count.index].to_port
  protocol          = var.rules[count.index].protocol
  cidr_blocks       = split(",", var.rules[count.index].cidr_blocks)
}
