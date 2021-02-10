variable "region" {
  description = "region"
  default = "eu-west-1"
}

variable project {
  description = "Project Name"
}

variable vpc_cidr {
  description = "Vpc cidr"
}

variable public_subnet_cidr {
  description = "public subnet cidr"
}

variable private_subnet_cidr {
  description = "private subnet cidr"
}

variable "availability_zone" {
  description = "availability zone"
  default = "eu-west-1a"
}

variable "ssh_ingress_cidr" {
  description = "ssh ingress cidr"
  default = "0.0.0.0/0"
}