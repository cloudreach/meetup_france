##############################################################################################################
# This part of code is to deploy all the security group needed for the EKS Demo
# 1 for EKS Cluster, 1 for EC2 Workers and 1 for ALB
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
# This is for meetup demo only, only allow your IP Range needed
##############################################################################################################
resource "aws_security_group" "cluster_kubernetes_security_group" {
  name        = "EKS-cluster-${var.cluster_name}-sg"
  vpc_id      = data.aws_vpc.meetup_vpc.id
  description = "Security group for masters and nodes"
  ingress {
    description = "Allow kubectl access from public cidr_blocks"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   #caution : this is done only for meetup part (EKS Is publicly accessible, and we open for WW, but this is not secure)
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.cluster_name}-sg"
  }
}
resource "aws_security_group_rule" "all-master-to-node" {
  type              = "ingress"
  description = "Allow EKS cluster to reach EC2 workers"
  security_group_id        = aws_security_group.cluster_kubernetes_security_group.id
  source_security_group_id = aws_security_group.cluster_kubernetes_security_group.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}


resource "aws_security_group" "alb" {
  name        = "alb-${var.cluster_name}-sg"
  vpc_id      = data.aws_vpc.meetup_vpc.id
  description = "Security group for ALB"
  ingress {
    description = "Allow HTTP traffic from WW"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow ALB to reach EC2 worker on port 30020"
    from_port   = 30020
    to_port     = 30020
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "alb-${var.cluster_name}-sg"
  }
}

resource "aws_security_group" "sg_worker_node" {
  name        = "Workers-${var.cluster_name}-sg"
  vpc_id      = data.aws_vpc.meetup_vpc.id
  description = "Security group for workernodes"
  egress {
    description = "Allow communication to WW, needed to worker joind cluster at bootstrap"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Workers-${var.cluster_name}-sg"
  }
}


resource "aws_security_group_rule" "cluster_access" {
  type              = "ingress"
  description       = "Allow all traffic from EKS Cluster"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_worker_node.id
  source_security_group_id = aws_security_group.cluster_kubernetes_security_group.id
}
resource "aws_security_group_rule" "ssh_access" {
  type              = "ingress"
  description       = "Allow SSH traffic from VPC"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_worker_node.id
  cidr_blocks = [var.vpc_range]
}
resource "aws_security_group_rule" "alb_access" {
  type              = "ingress"
  description       = "Allow traffic from ALB"
  from_port         = 30020
  to_port           = 30020
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_worker_node.id
  source_security_group_id = aws_security_group.alb.id
}