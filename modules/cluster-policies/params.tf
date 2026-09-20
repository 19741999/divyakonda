locals {
  policy_name     = "POLICY_RND_AB_CLAIMS_DOCUMIND_POC_RND_PROD"
  ad_group_prefix = "_AWS_SM_EDP_AI"
  ad_group_suffix = "CLAIMS_RND_PROD"

  # NOTE: the cluster-size / worker-count columns for this policy were not
  # legible in the source screenshot. The definition below is a reasonable
  # starting point (personal-compute style policy open to every user) -
  # replace it with your actual policy JSON once you can confirm the values.
  definition = {
    "spark_version" = {
      type = "unlimited"
    }
  }
}
