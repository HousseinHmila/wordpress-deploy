resource "aws_db_instance" "example" {
  identifier                          = var.rds_instance_id
  engine                              = "mysql"
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  username                            = var.db_username
  password                            = var.db_password
  parameter_group_name                = "default.mysql8.0"
  vpc_security_group_ids              = [aws_security_group.rds_sg.id]
  db_subnet_group_name                = aws_db_subnet_group.example.name
  publicly_accessible                 = false
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true

}
resource "aws_iam_role" "rds_s3_role" {
  name = "rds_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "rds_s3_policy" {
  role       = aws_iam_role.rds_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

