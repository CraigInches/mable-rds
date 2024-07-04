data "aws_caller_identity" "current" {}

resource "aws_db_instance" "rds" {
  db_name                             = var.app_name
  allocated_storage                   = var.db_storage_size
  engine                              = "mysql"
  engine_version                      = "8.0"
  storage_type                        = "gp3"
  iops                                = var.db_iops
  iam_database_authentication_enabled = true
  deletion_protection                 = true
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = var.kms_key
  storage_encrypted                   = true
  backup_retention_period             = var.backup_retention
  db_subnet_group_name                = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_idis             = [aws_security_group.rds-eks]
  parameter_group_name                = aws_db_parameter_group.name
}

resource "aws_db_parameter_group" "rds_param" {
  name   = "ExampleApp Param Group"
  family = "mysql8.0"

  parameter {
    name  = "statement_timeout"
    value = "3600000"
  }

  parameter {
    name  = "rds.log_retention_period"
    value = "1440"
  }
}
resource "aws_iam_policy" "rds-iam-policy" {
  name        = "rds_iam_example_app_auth"
  path        = "/"
  description = "enabling IAM Auth for example app DB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["rds-db:connect", ]
        Resource = "${data.aws_caller_identity.current.account_id}:db-user:${aws_db_instance.rds.db_name}"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds-iam-attachment" {
  role       = var.application_role
  policy_arn = aws_iam_policy.rds-iam-policy.arn
}

resource "aws_subnet" "rds" {
  vpc_id     = var.vpc_id
  cidr_block = var.rds_subnet
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds"
  subnet_ids = [rds]
}

resource "aws_security_group" "rds-eks" {
  name        = "rds_example_app"
  description = "rds and eks security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
  cidr_blocks = [var.eks_subnet]
}
