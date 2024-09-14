resource "aws_s3_bucket" "terraform_state" {
  bucket = "s3-us-east-2-terraform-state"
}

data "aws_iam_policy_document" "terraform_state" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.terraform_state.arn
    ]
    sid = "AllowS3ListToTerraform"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.aws_account_id}:role/terraform"
      ]
    }
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.terraform_state.arn}/*"
    ]
    sid = "AllowS3ToTerraform"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.aws_account_id}:role/terraform"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state.json
}

# Use S3 bucket keys for encryption instead of KMS to lower costs.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
