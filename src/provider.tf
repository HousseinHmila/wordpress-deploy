provider "aws" {
  region = var.region
}
provider "kubernetes" {
  host                   = aws_eks_cluster.example.endpoint
  token                  = data.aws_eks_cluster_auth.example.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority[0].data)
}

data "aws_eks_cluster_auth" "example" {
  name = aws_eks_cluster.example.name
}