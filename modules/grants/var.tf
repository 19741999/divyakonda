variable "catalog_name" {
  type = string
}

variable "schema_names" {
  description = "Map of 'stage_domain' => fully qualified schema name (output from the schemas module)"
  type        = map(string)
}

variable "external_location_names" {
  description = "Map of 'stage_domain' => external location name (output from the external-locations module)"
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

variable "roles" {
  description = "AD role codes that receive access within each domain (e.g. DS_DEV, DS_LEAD, AIE_DEV)"
  type        = list(string)
  default     = ["DS_DEV", "DS_LEAD", "AIE_DEV"]
}
