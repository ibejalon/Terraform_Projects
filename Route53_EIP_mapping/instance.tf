resource "aws_instance" "server1" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.project-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

# this is to give EIP to instance
resource "aws_eip" "server1" {
  instance = aws_instance.server1.id
  depends_on = [aws_internet_gateway.project-gw]
  vpc = true
}
# output the EIP for readability
output "ip" {
  value = aws_eip.server1.public_ip
}
