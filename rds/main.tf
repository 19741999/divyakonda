# ---------------------------------------------------------------------------
# Existing SageMaker execution roles (looked up by name)
# ---------------------------------------------------------------------------
data "aws_iam_role" "sagemaker" {
  for_each = toset(var.sagemaker_execution_role_names)
  name     = each.value
}

# ---------------------------------------------------------------------------
# Networking: subnet group + security group (only SageMaker can connect)
# ---------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.resource_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_security_group" "db" {
  name        = "${var.resource_prefix}-db-sg"
  description = "Allow PostgreSQL from SageMaker"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.resource_prefix}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_sagemaker" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = var.sagemaker_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "PostgreSQL from SageMaker"
}

# ---------------------------------------------------------------------------
# RDS instance (encrypted with the default AWS-managed key)
# ---------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier     = "${var.resource_prefix}-db"
  engine         = "postgres"
  engine_version = var.db_engine_version
  instance_class = local.settings.instance_class

  allocated_storage     = local.settings.allocated_storage
  max_allocated_storage = local.settings.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true # password stored in Secrets Manager

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  multi_az               = local.settings.multi_az

  backup_retention_period   = local.settings.backup_retention_days
  deletion_protection       = local.settings.deletion_protection
  skip_final_snapshot       = local.settings.skip_final_snapshot
  final_snapshot_identifier = local.settings.skip_final_snapshot ? null : "${var.resource_prefix}-db-final"

  auto_minor_version_upgrade   = true
  performance_insights_enabled = local.settings.performance_insights

  tags = {
    Name        = "${var.resource_prefix}-db"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------------------
# Let the SageMaker roles read the DB secret
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "sagemaker_db_access" {
  statement {
    sid       = "ReadDbSecret"
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [aws_db_instance.this.master_user_secret[0].secret_arn]
  }
}

resource "aws_iam_role_policy" "sagemaker_db_access" {
  for_each = data.aws_iam_role.sagemaker

  name   = "${var.resource_prefix}-db-access"
  role   = each.value.name
  policy = data.aws_iam_policy_document.sagemaker_db_access.json
}
