resource "aws_instance" "bastion" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id = element(var.PUBLIC_SUBNETS, 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = var.KEY_NAME

  tags = {
    Name         = "bastion-${var.ENV}"
    Environmnent = var.ENV
  }
}