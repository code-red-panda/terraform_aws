terraform {
  backend "s3" {
    bucket         = "s3-us-east-2-terraform-state"
    dynamodb_table = "dynamodb_us_east_2_terraform_state"
    encrypt        = true
    key            = "terraform.tfstate"
    profile        = "terraform"
    region         = "us-east-2"
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-east-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/terraform"
  }

  default_tags {
    tags = {
      Terraform_Managed = "true"
    }
  }
}
