# Udagram VPC
resource "aws_vpc" "udagram" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "udagram"
  }
}

# Subnets
resource "aws_subnet" "udagram-public-1" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "udagram-public-1"
  }
}

resource "aws_subnet" "udagram-public-2" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "udagram-public-2"
  }
}

resource "aws_subnet" "udagram-private-1" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "udagram-private-1"
  }
}

resource "aws_subnet" "udagram-private-2" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "udagram-private-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "udagram-gw" {
  vpc_id = aws_vpc.udagram.id

  tags = {
    Name = "udagram"
  }
}

# Route tables
resource "aws_route_table" "udagram-public" {
  vpc_id = aws_vpc.udagram.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.udagram-gw.id
  }

  tags = {
    Name = "udagram-public-1"
  }
}

# Route associations public
resource "aws_route_table_association" "udagram-public-1-a" {
  subnet_id      = aws_subnet.udagram-public-1.id
  route_table_id = aws_route_table.udagram-public.id
}

resource "aws_route_table_association" "udagram-public-2-a" {
  subnet_id      = aws_subnet.udagram-public-2.id
  route_table_id = aws_route_table.udagram-public.id
}
