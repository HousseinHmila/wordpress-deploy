# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster
data "aws_eks_cluster" "cluster" {
  #   depends_on = [module.eks]
  name = module.eks.cluster_id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth
data "aws_eks_cluster_auth" "cluster_auth" {
  #   depends_on = [module.eks]
  name = module.eks.cluster_id
}
