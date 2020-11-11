##############################################################################################################
# This part is used to create the k8s workers using autoscaling group and launch template.
# for the meetup I deploy only 1 ASG for the entire region, but it's better to deploy 1 ASG per availability zone.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
# https://docs.aws.amazon.com/eks/latest/userguide/worker.html
# user data : https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
##############################################################################################################
resource "aws_autoscaling_group" "asg_worker_nodes" {
  name                      = "worker-nodes-${var.cluster_name}"
  max_size                  = 3
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 3
  force_delete              = true
  vpc_zone_identifier       = data.aws_subnet_ids.private_subnets.ids
  target_group_arns         = module.alb.target_group_arns

  launch_template {
    id      = aws_launch_template.lc_worker_nodes.id
    version = "$Latest"
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "lc_worker_nodes" {
  image_id      = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_worker_node.id]
  user_data = base64encode(local.eks_node_user_data)
  iam_instance_profile {
    name = aws_iam_instance_profile.worker_ec2_instance_profile.name
  }
  key_name = var.key_pair
}

locals {
  eks_node_user_data = <<USERDATA
#!/bin/bash -xe
sudo /etc/eks/bootstrap.sh ${var.cluster_name} --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority[0].data}'
USERDATA
}