variable "storage_credential_name" {
  type        = string
  description = "Databricks storage credential these external locations use (output from the catalog module)"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name backing these external locations (output from the s3 module)"
}

variable "domains" {
  type = map(object({
    schema_prefix   = string
    location_suffix = string
    ad_domain_code  = string
  }))
}

variable "stages" {
  type    = list(string)
  default = ["poc", "wrk"]
}
