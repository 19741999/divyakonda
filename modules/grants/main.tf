locals {
  # AD group name per domain/role, e.g. _AWS_SM_EDP_AI_DS_DEV_DOCMD_CLAIMS_RND_PROD
  domain_groups = {
    for dk, d in var.domains :
    dk => [for r in var.roles : "${local.ad_group_prefix}_${r}_${d.ad_domain_code}_${local.ad_group_suffix}"]
  }

  all_groups = distinct(flatten([for dk, g in local.domain_groups : g]))

  # "stage_domain" key => domain key, so schema/location grants can look up
  # the right AD groups without parsing the composite key string.
  key_domain = merge([
    for dk, d in var.domains : {
      for s in var.stages : "${s}_${dk}" => dk
    }
  ]...)
}

# ---------------------------------------------------------------------------
# Catalog-level: USE CATALOG for every domain's AD groups
# ---------------------------------------------------------------------------
resource "databricks_grants" "catalog" {
  catalog = var.catalog_name

  dynamic "grant" {
    for_each = local.all_groups
    content {
      principal  = grant.value
      privileges = ["USE_CATALOG"]
    }
  }
}

# ---------------------------------------------------------------------------
# Schema-level grants, per domain/stage, to that domain's AD groups
# ---------------------------------------------------------------------------
resource "databricks_grants" "schema" {
  for_each = var.schema_names

  schema = each.value

  dynamic "grant" {
    for_each = local.domain_groups[local.key_domain[each.key]]
    content {
      principal  = grant.value
      privileges = local.schema_privileges
    }
  }
}

# ---------------------------------------------------------------------------
# External-location-level grants, per domain/stage, to that domain's AD groups
# ---------------------------------------------------------------------------
resource "databricks_grants" "external_location" {
  for_each = var.external_location_names

  external_location = each.value

  dynamic "grant" {
    for_each = local.domain_groups[local.key_domain[each.key]]
    content {
      principal  = grant.value
      privileges = local.external_location_privileges
    }
  }
}
