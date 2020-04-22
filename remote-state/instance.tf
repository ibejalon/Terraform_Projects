resource "aws_instance" "my_instance_practice" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo ${aws_instance.my_instance_practice.private_ip} >> private_ip.txt"
  }
}

output "IP_address" {
  value = aws_instance.my_instance_practice.public_ip
}

