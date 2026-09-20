locals {
  location_pairs = merge([
    for dk, d in var.domains : {
      for s in var.stages :
      "${s}_${dk}" => {
        name = "loc_edp_ai_rnd_ab_claims_${s}_${d.location_suffix}"
        url  = "s3://${var.bucket_name}/${s}-${d.schema_prefix}/"
      }
    }
  ]...)
}

resource "databricks_external_location" "this" {
  for_each = local.location_pairs

  name            = each.value.name
  url             = each.value.url
  credential_name = var.storage_credential_name
  comment         = "External location for ${each.key}"
}

output "location_names" {
  description = "Map of 'stage_domain' => external location name"
  value       = { for k, v in databricks_external_location.this : k => v.name }
}

output "location_urls" {
  description = "Map of 'stage_domain' => external location S3 URL"
  value       = { for k, v in databricks_external_location.this : k => v.url }
}
