# Internet VPC
resource "aws_vpc" "project" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "project"
  }
}

# Subnets
resource "aws_subnet" "project-public-1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "project-public-1"
  }
}

resource "aws_subnet" "project-public-2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "project-public-2"
  }
}

resource "aws_subnet" "project-public-3" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2c"

  tags = {
    Name = "project-public-3"
  }
}

resource "aws_subnet" "project-private-1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "project-private-1"
  }
}

resource "aws_subnet" "project-private-2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "project-private-2"
  }
}

resource "aws_subnet" "project-private-3" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2c"

  tags = {
    Name = "project-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "project-gw" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name = "project"
  }
}

# route tables
resource "aws_route_table" "project-public" {
  vpc_id = aws_vpc.project.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-gw.id
  }

  tags = {
    Name = "project-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "project-public-1-a" {
  subnet_id      = aws_subnet.project-public-1.id
  route_table_id = aws_route_table.project-public.id
}

resource "aws_route_table_association" "project-public-2-a" {
  subnet_id      = aws_subnet.project-public-2.id
  route_table_id = aws_route_table.project-public.id
}

resource "aws_route_table_association" "project-public-3-a" {
  subnet_id      = aws_subnet.project-public-3.id
  route_table_id = aws_route_table.project-public.id
}

