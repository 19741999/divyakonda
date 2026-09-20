resource "aws_s3_bucket" "name" {
  bucket = local.bucket_name

  tags = merge(var.tags, {
    Confidentiality = local.bucket_confidentiality
    Comments        = local.bucket_comments
  })
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket                  = aws_s3_bucket.name.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.name.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.name.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.name.arn
}
