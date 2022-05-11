# DevTestSecOps

## 1. Perequisites

1. Genarate ssh key
in Root repository folder

```
ssh-keygen -q -t rsa -b 2048 -N '' -f .ssh/ec2-key <<<y
chmod 400 .ssh/es2-key
```
Copy **.ssh** folder into **Test** folder 

2. Put value into TF/deploy.tfvars

|Var               |Desc                         |Default    |
|------------------|-----------------------------|-----------|
|first_name        |Any you want value           |Ivan       |
|last_name         |Any you want value           |Maria      |
|current_date      |Current date                 |           |
|application_config|EC2 instance configuration   |           |
|application_sg    |Security groups configuration|           |

application_config format:
```yaml
[
      {
          instance_name = string # Name EC2 instance
          instance_type = string # Type EC2 instance (for example t2.micro)
      }
]
```

application_sg format:
```yaml
[
     {
          sg_name - Name security group
          vpc_id  - VPC ID #Corrently doesn't use!
          rules = [
            {
              type        - Rule type 
              from_port   - Port from 
              to_port     - Port to
              protocol    = Protocol type
              cidr_blocks = CIDR block (string, use comma for CIDR delimiter)
            }, ...
          ]
     },
  ...
]
```

See example: TF/deploy.tfvars

**All code below runs in the TF folder**
## 2. Init
Backend configuration places into backend.hcl 
```
terraform init -backend-config=backend.hcl
```

## 3. Apply

```
terraform apply -auto-approve -var-file="deploy.tfvars"
```

Save output to file
```
terraform apply -auto-approve -no-color -var-file="deploy.tfvars" | tee output/out.txt
```
See example output/out.txt

## 4. Destroy

```
terraform destroy -auto-approve -var-file="deploy.tfvars"
```
