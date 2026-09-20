resource "databricks_cluster" "this" {
  for_each = local.clusters

  cluster_name             = each.value.cluster_name
  spark_version             = var.spark_version
  node_type_id              = var.node_type_id
  autotermination_minutes   = each.value.autotermination_minutes
  policy_id                 = var.cluster_policy_id
  data_security_mode        = "USER_ISOLATION" # "Shared Cluster" per source

  autoscale {
    min_workers = each.value.min_workers
    max_workers = each.value.max_workers
  }
}

resource "databricks_permissions" "cluster" {
  for_each = local.clusters

  cluster_id = databricks_cluster.this[each.key].id

  dynamic "access_control" {
    for_each = each.value.user_groups
    content {
      group_name       = access_control.value
      permission_level = "CAN_RESTART"
    }
  }
}

output "cluster_ids" {
  value = { for k, v in databricks_cluster.this : k => v.id }
}
