bucket         = "terraform-state-ev-20220101"
key            = "Test/terraform.tfstate"
region         = "eu-central-1"
dynamodb_table = "terraform_state_locks"
encrypt        = true
