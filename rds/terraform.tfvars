locals {
  env_settings = {
    dev = {
      instance_class        = "db.t3.medium"
      allocated_storage     = 20
      max_allocated_storage = 100
      multi_az              = false
      backup_retention_days = 1
      deletion_protection   = false
      skip_final_snapshot   = true
      performance_insights  = false
    }

    staging = {
      instance_class        = "db.t3.large"
      allocated_storage     = 50
      max_allocated_storage = 200
      multi_az              = false
      backup_retention_days = 7
      deletion_protection   = false
      skip_final_snapshot   = true
      performance_insights  = true
    }

    prod = {
      instance_class        = "db.r6g.large"
      allocated_storage     = 100
      max_allocated_storage = 500
      multi_az              = true
      backup_retention_days = 14
      deletion_protection   = true
      skip_final_snapshot   = false
      performance_insights  = true
    }
  }

  settings   = local.env_settings[var.environment]
  account_id = data.aws_caller_identity.current.account_id
}
