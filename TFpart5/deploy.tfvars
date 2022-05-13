key_name = "ec2-key"

ami = {
  name   = "name"
  values = "amzn2-ami-ecs-hvm-2.0.20220509-x86_64-ebs"
  owners = "amazon"
}

application_sg = [
  {
    sg_name = "asg_sg"
    vpc_id  = "vpc-06f0b421813177d82"
    rules = [
      { type        = "ingress"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        type        = "egress"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
  }
]

instance_profile = {
  profile_name = "my_profile_asg"
  role_name    = "my_role_asg"
}

asg = {
  asg_config = {
    name                = "my_asg"
    desired_capacity    = 1
    max_size            = 1
    min_size            = 1
    vpc_zone_identifier = ["subnet-025c92a1e0175884f", "subnet-084501e42169d0a5d"]
  }
  launch_config = {
    name          = "my_launch"
    instance_type = "t2.micro"
  }
}

ecs = {
  ecs_name = "my_ecs"
  ecs_service_config = {
    desired_count = 1
    name          = "my_ecs_service"
  }
  ecs_task_config = {
    name                     = "my_ecs_task"
    requires_compatibilities = ["EC2"]
  }
}

ecs_container_config = {
  cpu    = 256
  image  = "centos:latest"
  memory = 512
  name   = "centos"
  port_mappings = [{
    containerPort = 22
    hostPort      = 2233
    protocol      = "tcp"
  }]
  command = ["ping","localhost"]
}
