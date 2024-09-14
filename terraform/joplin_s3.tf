resource "aws_s3_bucket" "joplin" {
  bucket = "s3-us-east-2-joplin"
}

data "aws_iam_policy_document" "joplin_s3" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.joplin.arn
    ]
    sid = "AllowS3ListToJoplin"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.aws_account_id}:user/joplin"
      ]
    }
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.joplin.arn}/*"
    ]
    sid = "AllowS3ToJoplin"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.aws_account_id}:user/joplin"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "joplin_s3" {
  bucket = aws_s3_bucket.joplin.id
  policy = data.aws_iam_policy_document.joplin_s3.json
}

# Use S3 bucket keys for encryption instead of KMS to lower costs.
resource "aws_s3_bucket_server_side_encryption_configuration" "joplin" {
  bucket = aws_s3_bucket.joplin.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "joplin" {
  bucket = aws_s3_bucket.joplin.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
