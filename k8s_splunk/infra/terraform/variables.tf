variable region {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable vpc_name {
  description = "Name of the VPC"
  type        = string
  default     = "eks-vpc"
}

variable vpc_cidr {
  description = "CIDR of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable private_subnets {
  description = "Private subnets CIDR list"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable public_subnets {
  description = "Public subnets CIDR list"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable eks_cluster_name {
  description = "EKS cluster name"
  type        = string
  default     = "eks-cluster"
}

variable eks_cluster_version {
  description = "EKS cluster version"
  type        = string
  default     = "1.18"
}

variable eks_node_group_instance_type {
  description = "EKS node group instances type"
  type        = string
  default     = "t3.small"
}

variable eks_node_group_desired_capacity {
  description = "EKS node group desired capacity"
  type        = number
  default     = 3
}

variable eks_master_usernames {
  description = "IAM usernames list to add as system:masters to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable signalfx_access_token {
  description = "Token used to authenticate your connection to SignalFx"
  type        = string
}

variable signalfx_realm {
  description = "Name of the realm in which your organization is hosted, as shown on your profile page in the SignalFx web application"
  type        = string
}
