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

- ext_ip       << Your proveder ip
- first_name   << What you want
- last_name    << What you want
- current_date << Current date

## 2. Apply

```
terraform init

terraform apply -auto-approve -var-file="deploy.tfvars" 
```

## 3. Destroy

```
terraform destroy -auto-approve -var-file="deploy.tfvars" 
```
