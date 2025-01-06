resource "aws_s3_bucket" "my_website_bucket" {
  bucket = "${var.stack_name}-bucket"
}

resource "aws_s3_bucket_website_configuration" "my_website_bucket_website" {
  bucket = aws_s3_bucket.my_website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "my_website_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "my_website_bucket_policy" {
  bucket = aws_s3_bucket.my_website_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.my_website_bucket.bucket}/*"
    }
  ]
}
POLICY
}