# ---------------------------------------------------------------------------
# Shared Databricks provider configuration.
#
# IMPORTANT: Terraform only loads *.tf files from the directory it's run in
# (or from a module it's explicitly pointed at) - a provider block cannot
# live in a separate folder and be auto-included by a sibling root module.
# This file is kept here as the single source of truth / template; copy it
# unchanged into every environment root that needs it (dev/databricks.tf is
# an exact copy for that reason - keep the two in sync, or replace the copy
# step with a symlink in your own repo/CI if you prefer).
# ---------------------------------------------------------------------------

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.50"
    }
  }
}

# Connects to your EXISTING Databricks workspace - Terraform does not
# create or manage the workspace itself, only resources inside it.
#
# Auth: use either a PAT (databricks_token) or an OAuth service principal
# (databricks_client_id/secret) - populate whichever pair you use and leave
# the other pair null.
provider "databricks" {
  host          = var.databricks_host
  token         = var.databricks_token
  client_id     = var.databricks_client_id
  client_secret = var.databricks_client_secret
}
