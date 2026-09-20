variable "domains" {
  type = map(object({
    schema_prefix   = string
    location_suffix = string
    ad_domain_code  = string
  }))
}

variable "roles" {
  type    = list(string)
  default = ["DS_DEV", "DS_LEAD", "AIE_DEV"]
}
