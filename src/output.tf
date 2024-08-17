# outputs.tf

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.example.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.example.endpoint
}

output "eks_cluster_version" {
  description = "The version of the EKS cluster"
  value       = aws_eks_cluster.example.version
}

output "rds_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.example.endpoint
}

output "rds_instance_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.example.port
}

output "rds_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.example.arn
}
