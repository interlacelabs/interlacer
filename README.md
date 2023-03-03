# packetproducer

packageproducer is an ecs based docker runner that can be triggered via lambda.

## initial setup
1. configure backend.tfvars, for example
```
bucket = "myuniquebucket-terraform-states"
key = "terraform.tfstate"
dynamodb_table = "TerraformStatelock"
profile = "terraform"
region = "us-east-1"
```
2. run terraform init
```
terraform init -backend-config=backend.tfvars
```

## plan or apply
1. run terraform plan with the backend.tfvars file:
```
terraform plan -var-file=backend.tfvars -var-file=variables.tfvars
```

