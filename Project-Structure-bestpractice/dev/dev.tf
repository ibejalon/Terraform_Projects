module "project-vpc" {
  source     = "../modules/vpc"
  ENV        = "dev"
  AWS_REGION = var.AWS_REGION
}

module "bastion" {
  source         = "../modules/bastion"
  ENV            = "dev"
  KEY_NAME       = "mykeypair-${var.ENV}"
  VPC_ID         = module.project-vpc.vpc_id
  PUBLIC_SUBNETS = module.project-vpc.public_subnets
}

module "jenkins" {
  source         = "../modules/jenkins-instance"
  ENV            = "dev"
  KEY_NAME       = "mykeypair-${var.ENV}"
  VPC_ID         = module.project-vpc.vpc_id
  PUBLIC_SUBNETS = module.project-vpc.public_subnets
}
