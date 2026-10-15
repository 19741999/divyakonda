variable "resource_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "environment" {
  description = "dev"
  type        = string
}

# ---- Existing SageMaker domain details 

variable "vpc_id" {
  description = "VPC of the existing SageMaker domain (database goes in the same VPC)"
  type        = string
}

variable "db_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group (at least 2 AZs)"
  type        = list(string)
}

variable "sagemaker_security_group_id" {
  description = "Security group used by the SageMaker apps (DefaultUserSettings.SecurityGroups)"
  type        = string
}

variable "sagemaker_execution_role_names" {
  description = "Names (not ARNs) of the existing SageMaker execution roles that need DB access"
  type        = list(string)
}

# ---- Database basics ----

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_engine_version" {
  description = "Major version is enough, AWS picks the latest minor"
  type        = string
  default     = "16"
}
