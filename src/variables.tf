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
  description = "SQL Database username"

}

variable "db_password" {
  description = "SQL Database password"
  sensitive   = true

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
  default     = "vpc-09ae72ba88b999730"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default = [
    "subnet-061f6ffefa83d4812",
    "subnet-0ebdfc227aff072fe",
  ]
}
variable "snapshot_identifier" {
  description = "Snapshot identifier"
  default     = "wordpress-snapshot"
}

variable "user_arn" {
  description = "User ARN"
  
}