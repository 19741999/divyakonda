variable "iam_role_arn" {
  type        = string
  description = "ARN of the IAM role Databricks assumes for storage access (output from the iam module)"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name backing the catalog storage root (output from the s3 module)"
}
