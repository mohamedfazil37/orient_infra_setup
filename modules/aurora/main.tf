resource "aws_db_subnet_group" "aurora" {
  name = "aurora-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_security_group" "aurora_sg" {
  vpc_id = var.vpc_id
  name = "aurora-sg"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "aurora-cluster"
  engine = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.0"
  master_username = var.db_username
  master_password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  skip_final_snapshot = true
  backup_retention_period = 7
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count = 1
  identifier = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class = "db.t3.micro"
  engine = "aurora-mysql"
  publicly_accessible = false
}
