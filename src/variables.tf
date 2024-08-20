# variables.tf

variable "region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  default     = "poly-cluster"
}

variable "rds_instance_id" {
  description = "ID of the RDS instance"
  default     = "wordpress-db"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
  default     = "admin123"
}

variable "instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS"
  default     = 20
}

variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-023fd8093178c2892"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default = [
    "subnet-0b70ec3f3d119018f",
    "subnet-0f107057109be1a5a",
  ]
}
variable "snapshot_identifier" {
  description = "Snapshot identifier"
  default     = "wordpress-snapshot"
  
}
