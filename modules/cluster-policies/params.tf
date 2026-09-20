locals {
  policy_name     = "POLICY_RND_AB_CLAIMS_DOCUMIND_POC_RND_PROD"
  ad_group_prefix = "_AWS_SM_EDP_AI"
  ad_group_suffix = "CLAIMS_RND_PROD"


  definition = {
    "spark_version" = {
      type = "unlimited"
    }
  }
}
