locals {
  all_groups = distinct(flatten([
    for dk, d in var.domains : [
      for r in var.roles : "${local.ad_group_prefix}_${r}_${d.ad_domain_code}_${local.ad_group_suffix}"
    ]
  ]))
}

resource "databricks_cluster_policy" "policy" {
  name       = local.policy_name
  definition = jsonencode(local.definition)
}

resource "databricks_permissions" "cluster_policy" {
  cluster_policy_id = databricks_cluster_policy.this.id

  dynamic "access_control" {
    for_each = local.all_groups
    content {
      group_name       = access_control.value
      permission_level = "CAN_USE"
    }
  }
}
