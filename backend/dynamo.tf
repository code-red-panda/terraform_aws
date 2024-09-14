locals {
  parition_key = "LockID"
}

resource "aws_dynamodb_table" "terraform_state" {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.parition_key
  name         = "dynamodb_us_east_2_terraform_state"

  attribute {
    name = local.parition_key
    type = "S"
  }
}
