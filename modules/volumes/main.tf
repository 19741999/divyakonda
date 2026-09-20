locals {
  volume_pairs = merge([
    for dk, d in var.domains : {
      for s in var.stages :
      "${s}_${dk}" => {
        name   = "edp_ai_${d.location_suffix}_${s}_rnd_prod"
        schema = var.schema_names["${s}_${dk}"]
        path   = "${trimsuffix(var.location_urls["${s}_${dk}"], "/")}/${local.volume_subpath}/"
      }
    }
  ]...)
}

resource "databricks_volume" "this" {
  for_each = local.volume_pairs

  name              = each.value.name
  catalog_name      = var.catalog_name
  schema_name       = split(".", each.value.schema)[1]
  volume_type       = "EXTERNAL"
  storage_location  = each.value.path
  comment           = "Unstructured file access volume for ${each.key}"
}

output "volume_names" {
  value = { for k, v in databricks_volume.this : k => v.name }
}
