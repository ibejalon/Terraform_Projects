# Securitygroup for the bastion host
resource "aws_security_group" "allow-ssh" {
  vpc_id      = aws_vpc.udagram.id
  name        = "allow"
  description = "security group that allows ssh and all egres traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion"
  }
}

# Securitygroup for servers in the private subnet
resource "aws_security_group" "myserver" {
  vpc_id      = aws_vpc.udagram.id
  name        = "myserver"
  description = "security group for my instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.udagram-elb-securitygroup.id]
  }

  tags = {
    Name = "myserver"
  }
}

resource "aws_security_group" "udagram-elb-securitygroup" {
  vpc_id      = aws_vpc.udagram.id
  name        = "udagram-elb"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "udagram-elb"
  }
}

