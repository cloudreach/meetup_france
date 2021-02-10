

###############################################################################
###################################### AMI ####################################
###############################################################################
data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*-x86_64-ebs"]
 }


  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }

}
###############################################################################
############################## Security group #################################
###############################################################################
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow ssh"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

###############################################################################
################################ Instance #####################################
###############################################################################
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name = "meetup"
  vpc_security_group_ids = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name    = "${var.project}_instance"
    project = var.project
    Billable = "no"
  }
}