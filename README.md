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

|Var               |Desc                       |Default    |
|------------------|---------------------------|-----------|
|ext_ip            |Your proveder ip           |0.0.0.0./0 |
|first_name        |Any you want value         |Ivan       |
|last_name         |Any you want value         |Maria      |
|current_date      |Current date               |           |
|application_config|EC2 instance configuration |           |

application_config format:
```yaml
[
      {
          instance_name = string # Name EC2 instance
          instance_type = string # Type EC2 instance (for example t2.micro)
      }
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

## 4. Destroy

```
terraform destroy -auto-approve -var-file="deploy.tfvars"
```
