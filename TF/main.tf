terraform {
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
  region  = "us-east-1"
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

resource "aws_security_group" "sg_apache" {
  name = "sg_apache"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ext_ip]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.ext_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ec2-key" {
    key_name = "ec2-key"
    public_key = file("../.ssh/ec2-key.pub")
}

resource "aws_instance" "DevTestSecOps" {
  ami           = data.aws_ami.aws.id
  instance_type = "t2.micro"
  key_name = "ec2-key"
  subnet_id = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.sg_apache.id]

  tags = {
    Name = "DevTestSecOps"
    Date_creation = timestamp()
    OS_type = data.aws_ami.aws.platform_details
    AWS_Account_ID = data.aws_caller_identity.current.account_id
    Your_First_Name = var.first_name
    Your_Last_Name = var.last_name
  }

  metadata_options {
    http_endpoint = "enabled"
    http_put_response_hop_limit = 1
    http_tokens = "optional"
    instance_metadata_tags = "enabled"
  }

  user_data = <<EOF
#!/bin/bash
sudo yum install -y httpd.x86_64
sudo systemctl enable httpd
sudo systemctl start httpd

echo '<!DOCTYPE html><html><body><h1 id="DevTestSecOps">AWS EC2</h1><table border="1" style="border-collapse: collapse; width: 100%;"><tbody><tr>' >index.html

for var in AWS_Account_ID Date_creation Name OS_type Your_First_Name Your_Last_Name
do
    echo '<td style="width: 20%;">' $var '</td>' >>index.html
done

echo '</tr><tr>' >>index.html

for var in AWS_Account_ID Date_creation Name OS_type Your_First_Name Your_Last_Name
do
    magic=$(curl http://169.254.169.254/latest/meta-data/tags/instance/$var)
    echo '<td style="width: 20%;">' $magic '</td>' >>index.html
done

echo '</tr></tbody></table></body></html>' >>index.html

sudo cp index.html /var/www/html/
EOF
}
