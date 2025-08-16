##############################
# S3 Bucket (private)
##############################
resource "aws_s3_bucket" "private_bucket" {
  bucket        = "${var.bucket_name}-${var.stage}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"
}

##############################
# S3 Lifecycle Rule
##############################
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    id     = "delete-logs"
    status = "Enabled"

    filter {
      prefix = "logs/"
    }

    expiration {
      days = 7
    }
  }
}
