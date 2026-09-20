locals {
 
  clusters = {
    documind_poc = {
      cluster_name             = "EDP_AI_AB_CLAIMS_DOCUMIND_POC_RND_PROD"
      autotermination_minutes  = 15
      min_workers              = 1
      max_workers              = 2
      user_groups = [
        "_AWS_SM_EDP_AI_DS_LEAD_DOCMD_CLAIMS_RND_PROD",
        "_AWS_SM_EDP_AI_AIE_DEV_DOCMD_CLAIMS_RND_PROD",
        "_AWS_SM_EDP_AI_PO_DEV_DOCMD_CLAIMS_RND_PROD",
      ]
    }
    documind_wrk = {
      cluster_name             = "EDP_AI_AB_CLAIMS_DOCUMIND_WRK_RND_PROD"
      autotermination_minutes  = 15
      min_workers              = 1
      max_workers              = 2
      user_groups = [
        "_AWS_SM_EDP_AI_DS_LEAD_DOCMD_CLAIMS_RND_PROD",
        "_AWS_SM_EDP_AI_AIE_DEV_DOCMD_CLAIMS_RND_PROD",
        "_AWS_SM_EDP_AI_PO_DEV_DOCMD_CLAIMS_RND_PROD",
      ]
    }
  }
}
