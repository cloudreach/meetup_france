##############################################################################################################
# This part of code is to load the VPC / Subnets informations in order to deploy resources
# For the demo we didn't used the remote state, more information here https://www.terraform.io/docs/backends/types/s3.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc#tags
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids
##############################################################################################################
data "aws_vpc" "meetup_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "public_subnets"{
    vpc_id = data.aws_vpc.meetup_vpc.id
    tags = {
        Name = "${var.vpc_name}-public-*"
    }
}

data "aws_subnet_ids" "private_subnets"{
    vpc_id = data.aws_vpc.meetup_vpc.id
    tags = {
        Name = "${var.vpc_name}-private-*"
    }
}