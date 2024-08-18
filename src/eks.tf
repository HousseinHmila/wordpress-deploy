# Existing EKS Cluster and Node Group
resource "aws_eks_cluster" "example" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.30"
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "worker-node"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = ["t3.micro"]
  capacity_type   = "ON_DEMAND"

  scaling_config {
    min_size     = 1
    max_size     = 2
    desired_size = 1
  }
}


# IAM Roles and Policies for EKS
resource "aws_iam_role" "eks_role" {
  name = "example-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_security_group" "eks_sg" {
  name        = "example-eks-sg"
  description = "Allow communication for EKS"
  vpc_id      = var.vpc_id
}



resource "aws_security_group_rule" "eks_node_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_node_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "kubernetes_config_map" "aws_auth" {
  depends_on = [
    aws_eks_cluster.example,
    aws_eks_node_group.example
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles" = <<EOF
- rolearn: arn:aws:iam::010526256256:role/eks-node-role
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: arn:aws:iam::010526256256:role/oidc_role
  username: github-actions
  groups:
    - system:masters
EOF
  }
}

