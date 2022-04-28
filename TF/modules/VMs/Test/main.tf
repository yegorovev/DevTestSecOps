terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "1.1.9"
}

resource "aws_instance" "test-t2-micro" {
  ami                    = var.aws_ami_id
  instance_type          = "t2.micro"
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
    Name            = "DevTestSecOps"
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
    source      = "./hello.txt"
    destination = "/tmp/hello.txt"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = var.private_key_value
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/hello.txt"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = var.private_key_value
    }
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
