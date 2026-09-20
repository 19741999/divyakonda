resource "databricks_storage_credential" "this" {
  name = local.storage_credential_name

  aws_iam_role {
    role_arn = var.iam_role_arn
  }

  comment = "RWD storage credential for s3://${var.bucket_name}"
}

resource "databricks_catalog" "this" {
  name         = local.catalog_name
  storage_root = "s3://${var.bucket_name}/"
  comment      = "Catalog backed by s3://${var.bucket_name}/"

  depends_on = [databricks_storage_credential.this]
}

output "catalog_name" {
  value = databricks_catalog.this.name
}

output "storage_credential_name" {
  value = databricks_storage_credential.this.name
}
