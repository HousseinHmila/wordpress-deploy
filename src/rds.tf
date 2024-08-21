
resource "aws_db_instance" "example" {
  identifier                          = var.rds_instance_id
  engine                              = "mysql" # or "mariadb"
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  vpc_security_group_ids              = [aws_security_group.rds_sg.id]
  db_subnet_group_name                = aws_db_subnet_group.example.name
  publicly_accessible                 = true
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  #snapshot_identifier                 = var.snapshot_identifier


  # Other DB parameters
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 0
}
