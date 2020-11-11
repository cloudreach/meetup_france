##############################################################################################################
# This part is used to create the cluster with the specific configuration (subnets, iam role, version etc)
# For the meetup, cause of a lab account, we are using a public configuration (subnets & access), but this is not recommended ;)
# You can activate logs for troubleshooting purpose (IAM role need to have the mandatory rights) We did not do this on this code.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
# https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html
##############################################################################################################
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = var.eks_version
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = data.aws_subnet_ids.public_subnets.ids
    security_group_ids = [aws_security_group.cluster_kubernetes_security_group.id]
  }
}
