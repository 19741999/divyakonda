locals {
  # Domain naming metadata shared across the schemas / external-locations /
  # volumes / grants modules. Add more entries here as new domains show up.
  domains = {
    documind = {
      schema_prefix   = "documind"
      location_suffix = "documind"
      ad_domain_code  = "DOCMD"
    }
    inver = {
      schema_prefix   = "inver"
      location_suffix = "inver"
      ad_domain_code  = "INVR"
    }
    legacy = {
      schema_prefix   = "legacy"
      location_suffix = "legacy_projects"
      ad_domain_code  = "LGCY"
    }
    settlement_assist = {
      schema_prefix   = "settlement_assist"
      location_suffix = "settlement_assist"
      ad_domain_code  = "SETASSIST"
    }
    dmaas = {
      schema_prefix   = "dmaas"
      location_suffix = "dmaas"
      ad_domain_code  = "DMAAS"
    }
  }

  stages = ["poc", "wrk"]

  common_tags = {
    Environment = var.environment
    Domain      = "edp-ai-claims"
    ManagedBy   = "terraform"
  }
}
