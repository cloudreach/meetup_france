module vpc {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  name = var.vpc_name
  cidr = var.vpc_range

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true

}