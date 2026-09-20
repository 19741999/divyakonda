variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "databricks_host" {
  type        = string
  description = "URL of your EXISTING Databricks workspace (e.g. https://<workspace>.cloud.databricks.com)"
}

variable "databricks_token" {
  type        = string
  description = "Databricks PAT used by the provider. Leave null if using OAuth service-principal auth instead."
  sensitive   = true
  default     = null
}

variable "databricks_client_id" {
  type        = string
  description = "OAuth service-principal client ID (recommended over a PAT for automation). Leave null if using databricks_token instead."
  default     = null
}

variable "databricks_client_secret" {
  type        = string
  description = "OAuth service-principal client secret. Leave null if using databricks_token instead."
  sensitive   = true
  default     = null
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID, used as the external ID in the IAM role's cross-account trust policy"
}
