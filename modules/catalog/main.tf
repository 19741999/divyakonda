resource "databricks_storage_credential" "name" {
  name = local.storage_credential_name
  aws_iam_role {
    role_arn = var.iam_role_arn
  }
}

resource "databricks_catalog" "name" {
  name         = local.catalog_name
  storage_root = "s3://${var.bucket_name}/"
  depends_on = [databricks_storage_credential.this]
}
