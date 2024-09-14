# In AWS...
Allow access for the `/backend` Terraform. This Terraform creates the state management resources for the `/terraform` Terraform.
- `terraform_state` user
- `terraform_state` role
Allow access for the `/terraform` Terraform. This Terraform creates all the fun stuff.
- `terraform` user
- `terraform` role

# On local machine...
Create `terraform` and `terraform_state` AWS configs in `~/.aws/config`
```
[terraform]
region = us-east-2
output = json

[terraform_state]
region = us-east-2
output = json
```

Create `terraform` and `terraform_state` AWS profiles in `~/.aws/credentials`
```
[terraform]
aws_access_key_id = XXX
aws_secret_access_key = XXX

[terraform_state]
aws_access_key_id = XXX
aws_secret_access_key = XXX
```

# One-time only steps
Add secrets to the `/backend` Terraform in `backend/secrets.tf`
```
# From the root of this project directory
vi backend/secrets.tf

locals {
  aws_account_id = "123456789"
}
```

Add secrets to the `/terraform` Terraform in `terraform/secrets.tf`
```
# From the root of this project directory
vi terraform/secrets.tf

locals {
  aws_account_id = "123456789"
}
```
Review the `CONTRIBUTING.md` to install and initialize utilities.

# Run Terraform
First, initialize, plan, and apply the `/backend` Terraform.
```
# From the root of this project directory
cd backend
terraform init
terraform plan
terraform apply
```

Next, initialize, plan, and apply the `/terraform` Terraform.
```
# From the root of this project directory
cd terraform
terraform init
terraform plan
terraform apply
```
