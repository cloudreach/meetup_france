data aws_caller_identity current {}

data aws_availability_zones available {
  state = "available"
}

data aws_eks_cluster cluster {
  name = module.eks.cluster_id
}

data aws_eks_cluster_auth cluster {
  name = module.eks.cluster_id
}

data aws_iam_user eks_master_users {
  count     = length(var.eks_master_usernames)
  user_name = var.eks_master_usernames[count.index]
}
