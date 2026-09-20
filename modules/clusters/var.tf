variable "cluster_policy_id" {
  type        = string
  description = "ID of the cluster policy these clusters should use (output from the cluster-policies module)"
}

variable "spark_version" {
  type        = string
  description = "Databricks Runtime version - placeholder, confirm against your workspace's approved DBR"
  default     = "13.3.x-scala2.12"
}

variable "node_type_id" {
  type        = string
  description = "Instance type for cluster nodes - placeholder, confirm the actual instance size (source screenshot showed 'large')"
  default     = "i3.xlarge"
}
