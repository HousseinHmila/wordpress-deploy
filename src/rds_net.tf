resource "aws_db_subnet_group" "example" {
  name       = "db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow communication for RDS"

  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    #security_groups = [module.eks.eks_cluster_sg_id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group_rule" "rds_allow_eks_sg" {
  # this rule is added to the security group defined by `security_group_id`
  # and this id target the `default` security group associated with the created VPC
  security_group_id = aws_security_group.rds_sg.id

  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # One of ['cidr_blocks', 'ipv6_cidr_blocks', 'self', 'source_security_group_id', 'prefix_list_ids']
  # must be set to create an AWS Security Group Rule
  source_security_group_id = module.eks.eks_managed_node_groups.worker-node.security_group_id

  lifecycle {
    create_before_destroy = true
  }
}
