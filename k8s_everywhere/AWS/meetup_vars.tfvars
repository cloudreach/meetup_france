### global variable
region = "" #put the region where you want to deploy
aws_profile = "" #your awscli profile

### network variables : proposed range for lab/demo purpose
vpc_range = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

### EKS variable for cluster and workers
instance_type = ""
eks_version = "" # 1.15 / 1.16 / 1.17 / 1.18
vpc_name = ""
cluster_name = ""
image_id = "" #ami created by official amazon-eks-ami repository
key_pair = "" # your keypair if you want to connect to workers
