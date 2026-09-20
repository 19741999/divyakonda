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

resource "databricks_schema" "schema" {
  for_each = local.schema_pairs

  catalog_name = var.catalog_name
  name         = each.value.name
  ##comment      = "Schema for ${each.value.domain} (${each.value.stage})"
}


