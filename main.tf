locals {
  name_prefix = "${var.env}-docdb"
    tags = merge(var.tags, { tf-module-name = "docdb"},{env = var.env})
}

resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.env}-docdb-cluster"
  engine                  = "docdb"
  master_username         = "foo"
  master_password         = "mustbeeightchars"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
}
