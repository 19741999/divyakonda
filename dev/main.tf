terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    # databricks provider requirement is declared in ./databricks.tf
  }

  backend "s3" {
    # Fill in with your remote state settings, e.g.:
    # bucket  = "tfstate-edp-ai-claims"
    # key     = "dev/edp-ai-claims.tfstate"
    # region  = "us-east-1"
    # encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

# --- S3 bucket ---------------------------------------------------------
module "s3" {
  source = "../modules/s3"
  tags   = local.common_tags
}

# --- IAM (policy + cross-account role) ----------------------------------
module "iam" {
  source                 = "../modules/iam"
  bucket_arn              = module.s3.bucket_arn
  databricks_account_id   = var.databricks_account_id
  tags                     = local.common_tags
}

# --- Databricks storage credential + catalog ----------------------------
module "catalog" {
  source       = "../modules/catalog"
  iam_role_arn = module.iam.role_arn
  bucket_name  = module.s3.bucket_name
}

# --- Schemas (10x: poc/wrk x 5 domains) ----------------------------------
module "schemas" {
  source       = "../modules/schemas"
  catalog_name = module.catalog.catalog_name
  domains      = local.domains
  stages       = local.stages
}

# --- External locations (10x) --------------------------------------------
module "external_locations" {
  source                   = "../modules/external-locations"
  storage_credential_name  = module.catalog.storage_credential_name
  bucket_name               = module.s3.bucket_name
  domains                   = local.domains
  stages                    = local.stages
}

# --- External volumes (10x) -----------------------------------------------
module "volumes" {
  source        = "../modules/volumes"
  catalog_name  = module.catalog.catalog_name
  schema_names  = module.schemas.schema_names
  location_urls = module.external_locations.location_urls
  domains       = local.domains
  stages        = local.stages
}

# --- Unity Catalog grants (catalog / schema / external location) --------
module "grants" {
  source                    = "../modules/grants"
  catalog_name               = module.catalog.catalog_name
  schema_names                = module.schemas.schema_names
  external_location_names    = module.external_locations.location_names
  domains                     = local.domains
  stages                      = local.stages
}

# --- Cluster policy --------------------------------------------------------
module "cluster_policies" {
  source  = "../modules/cluster-policies"
  domains = local.domains
}

# --- Clusters ----------------------------------------------------------------
module "clusters" {
  source            = "../modules/clusters"
  cluster_policy_id = module.cluster_policies.policy_id
}

output "bucket_arn" {
  value = module.s3.bucket_arn
}

output "catalog_name" {
  value = module.catalog.catalog_name
}

output "schema_names" {
  value = module.schemas.schema_names
}

output "volume_names" {
  value = module.volumes.volume_names
}

output "cluster_ids" {
  value = module.clusters.cluster_ids
}
