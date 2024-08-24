module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.30"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    disk_size      = 8
    instance_types = ["t2.medium"]
  }

  # Add IAM user ARNs to aws-auth configmap to be able to manage EKS from the AWS website

  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md#input_create_aws_auth_configmap
  # create_aws_auth_configmap = true

  # /!\ https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911#issuecomment-640702294
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md#input_manage_aws_auth_configmap
  manage_aws_auth_configmap = true
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md#input_aws_auth_users
  aws_auth_users = [
    {
      "userarn" : "${var.user_arn}",
      "groups" : ["system:masters"]
    }
  ]
  eks_managed_node_groups = {

    worker-node = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND" # SPOT
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

}

