module eks {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "13.2.1"
  cluster_name              = var.eks_cluster_name
  cluster_version           = var.eks_cluster_version
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  subnets                   = module.vpc.private_subnets
  vpc_id                    = module.vpc.vpc_id
  map_users = [
    for user in data.aws_iam_user.eks_master_users : {
      userarn  = user.arn
      username = user.user_name
      groups   = ["system:masters"]
    }
  ]
  node_groups = {
    group1 = {
      name             = "workers-group1"
      instance_type    = var.eks_node_group_instance_type
      desired_capacity = var.eks_node_group_desired_capacity
    }
  }
}

