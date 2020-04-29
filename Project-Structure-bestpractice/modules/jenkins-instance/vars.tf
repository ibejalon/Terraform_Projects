###########################
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

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}

variable "APP_INSTANCE_COUNT" {
  default = "0"
}

variable "TERRAFORM_VERSION" {
  default = "0.12.18"
}

variable "KEY_NAME" {
}
