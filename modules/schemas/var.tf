variable "catalog_name" {
  type        = string
  description = "Unity Catalog catalog these schemas belong to"
}

variable "domains" {
  description = "Map of domain key => domain naming metadata (schema_prefix, location_suffix, ad_domain_code)"
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
