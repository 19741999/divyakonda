variable "catalog_name" {
  type = string
}

variable "schema_names" {
  description = "Map of 'stage_domain' => fully qualified schema name (output from the schemas module)"
  type        = map(string)
}

variable "location_urls" {
  description = "Map of 'stage_domain' => external location S3 URL (output from the external-locations module)"
  type        = map(string)
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
