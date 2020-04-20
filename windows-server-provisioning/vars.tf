variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "us-east-2"
}

variable "WIN_AMIS" {
  type = map(string)
  default = {
    us-east-2 = "ami-07f3715a1f6dbb6d9"
    us-west-1 = "ami-0037082364387ada7"
    us-west-2 = "ami-0f467e652b07f3676"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "Terraform"
}

variable "INSTANCE_PASSWORD" {
}

