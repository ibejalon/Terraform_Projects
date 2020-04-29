variable "ENV" {
}

variable "AWS_REGION" {
  default = "us-west-2"
}

variable "VPC_ID" {
}

variable "PUBLIC_SUBNETS" {
  type = list
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-2 = "ami-0fc20dd1da406780b"
    us-west-1 = "ami-03ba3948f6c37a4b0"
    us-west-2 = "ami-0d1cd67c26f5fca19"
  }
}

variable "KEY_NAME" {
}

