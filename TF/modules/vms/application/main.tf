terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "1.1.9"
}

resource "aws_instance" "application" {
  ami                    = var.aws_ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  /*
  https://github.com/hashicorp/terraform-provider-aws/issues/19583

│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for aws_instance.DevTestSecOps to include new values learned so far during apply, provider
│ "registry.terraform.io/hashicorp/aws" produced an invalid new value for .tags_all: new element "Your_Last_Name" has appeared.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.

  Date_creation = timestamp() <<<<!!!!!!
  */
  tags = {
    Name            = var.instance_name
    Date_creation   = var.current_date
    OS_type         = var.platform_details
    AWS_Account_ID  = var.account_id
    Your_First_Name = var.first_name
    Your_Last_Name  = var.last_name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }

  provisioner "file" {
    source      = join("/", ["${path.module}", var.local_files_source.hello_path])
    destination = var.hello_file_remote_path
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = var.private_key_value
    }
  }

  user_data = file(join("/", ["${path.module}", var.local_files_source.user_data_path]))
}
