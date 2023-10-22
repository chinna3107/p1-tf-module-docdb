locals {
  name_prefix = "${var.env}-docdb"
    tags = merge(var.tags, { tf-module-name = "docdb"},{env = var.env})
}

resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags, {Name = "${local.name_prefix}-sg"})

  ingress {
    description = "docdb"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb4.0"
  name        =  "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  tags = merge(local.tags, {Name = "${local.name_prefix}-pg"})
}


resource "aws_docdb_cluster" "main" {
  cluster_identifier              = "${var.env}-docdb-cluster"
  engine                          = "docdb"
  master_username                 = data.aws_ssm_parameter.master_username.value
  master_password                 = data.aws_ssm_parameter.master_password.value
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = var.skip_final_snapshot
  db_subnet_group_name            = [aws_security_group.main.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  tags                            = merge(local.tags, {Name = "${local.name_prefix}-cluster"})
}


