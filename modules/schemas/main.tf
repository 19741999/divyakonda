locals {
  schema_pairs = merge([
    for dk, d in var.domains : {
      for s in var.stages :
      "${s}_${dk}" => {
        name   = "sch_${s}_${d.schema_prefix}"
        domain = dk
        stage  = s
      }
    }
  ]...)
}

resource "databricks_schema" "this" {
  for_each = local.schema_pairs

  catalog_name = var.catalog_name
  name         = each.value.name
  comment      = "Schema for ${each.value.domain} (${each.value.stage})"
}

output "schema_names" {
  description = "Map of 'stage_domain' => fully qualified schema name (catalog.schema)"
  value       = { for k, v in databricks_schema.this : k => "${var.catalog_name}.${v.name}" }
}
