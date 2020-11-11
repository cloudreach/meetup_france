##############################################################################################################
# This part of code is to deploy the Public Load balacing part to broswe application after deployment.
# We are using the official ALB module from Terraform registry
# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest
# This configuration is only for our demo, for the arget Group configuration & healthcheck with fixed port
# On AWS best way is to use the alb-ingress-controller.
# https://github.com/kubernetes-sigs/aws-load-balancer-controller
##############################################################################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  name = "alb-k8s-meetup-demo"
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.meetup_vpc.id
  subnets            = data.aws_subnet_ids.public_subnets.ids
  security_groups    = [aws_security_group.alb.id]
  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 30020
      target_type      = "instance"
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}