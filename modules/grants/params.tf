locals {
  ad_group_prefix = "_AWS_SM_EDP_AI"
  ad_group_suffix = "CLAIMS_RND_PROD"

  # Per-schema privileges granted to each domain's AD groups
  schema_privileges = ["USE_SCHEMA", "CREATE_FUNCTION", "READ_VOLUME", "WRITE_VOLUME", "CREATE_TABLE"]

  # Per-external-location privileges (tables/volumes are written by the
  # databricks process, per the source inventory's "Comments" column)
  external_location_privileges = ["CREATE_EXTERNAL_TABLE", "CREATE_EXTERNAL_VOLUME"]
}
