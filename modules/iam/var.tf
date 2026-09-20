variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket to grant RWD access to (output from the s3 module)"
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID, used as external_id in the cross-account trust policy"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
}
