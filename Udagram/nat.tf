# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.udagram-public-1.id
  depends_on    = [aws_internet_gateway.udagram-gw]
}

# Route table for nat-gw
resource "aws_route_table" "udagram-private" {
  vpc_id = aws_vpc.udagram.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "udagram-private-1"
  }
}

# Route associations for private subnet
resource "aws_route_table_association" "udagram-private-1-a" {
  subnet_id      = aws_subnet.udagram-private-1.id
  route_table_id = aws_route_table.udagram-private.id
}

resource "aws_route_table_association" "udagram-private-2-a" {
  subnet_id      = aws_subnet.udagram-private-2.id
  route_table_id = aws_route_table.udagram-private.id
}

