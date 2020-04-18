provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-2"
}

resource "aws_instance" "sample" {
  ami           = "ami-0d1cd67c26f5fca19"
  instance_type = "t2.micro"
}

