output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.project-vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.project-vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.project-vpc.public_subnets
}
