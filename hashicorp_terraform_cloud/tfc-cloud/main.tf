###############################################################################
###################################### VPC ####################################
###############################################################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project}_vpc"
    project = var.project
  }

}

###############################################################################
################################## Subnets ####################################
###############################################################################

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name    = "${var.project}_public_subnet"
    project = var.project
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name    = "${var.project}_private_subnet"
    project = var.project
  }
}

###############################################################################
################################# Igw and route ###############################
###############################################################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags =  {
    Name    = "${var.project}_igw"
    project = var.project
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name    = "${var.project}_public_rt"
    project = var.project
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

###############################################################################
############################### Ngw and route #################################
###############################################################################

resource "aws_eip" "ngw" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "${var.project}_private_rt"
    project = var.project
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
