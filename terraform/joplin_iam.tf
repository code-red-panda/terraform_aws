resource "aws_iam_user" "joplin" {
  name = "joplin"
}

data "aws_iam_policy_document" "joplin_user" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.joplin.arn
    ]
    sid = "AllowS3ListToJoplin"
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
  }
}

resource "aws_iam_user_policy" "joplin_user" {
  name   = "joplin"
  user   = aws_iam_user.joplin.name
  policy = data.aws_iam_policy_document.joplin_user.json
}
