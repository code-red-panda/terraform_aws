# Use the "terraform_state" profile to authenticate with AWS.
# Assume the "terraform_state" role to elevate privileges.
provider "aws" {
  profile = "terraform_state"
  region  = "us-east-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/terraform_state"
  }

  default_tags {
    tags = {
      Terraform_Managed = "true"
    }
  }
}
