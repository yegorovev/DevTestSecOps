# Example values
first_name   = "E"
last_name    = "E"
current_date = "28/04/2020"
application_config = [
  {
    instance_name = "test"
    instance_type = "t2.micro"
  }
  ,
  {
    instance_name = "test2"
    instance_type = "t2.micro"
  }
]

application_sg = [
  {
    sg_name = "test_ingress"
    vpc_id  = ""
    rules = [
      { type        = "ingress"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      },
#  Test case:
#  in case we need to delete one of the sg rules in the middle of the list, 
#  it needs to be done without any sg rule re-creation
      { type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      { type        = "ingress"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
  },
  {
    sg_name       = "test_egress"
    vpc_id        = ""
    rules = [{
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      }
    ]
  }
]
