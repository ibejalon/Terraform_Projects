**Infrastructure as Code Using Terraform Project**

Udagram is a fictitious instagram clone whose code has been pushed to S3 Bucket.

My task is to deploy the application by creating the following  infrastructure:

- VPC: The private cloud environment needed to spin up resources for Udagram
- Availability Zones: Two availability zones created for failover
- Bastion Host : The host server
- VPC NAT Gateway: lets private subnets route to the public
- Internet gateway with corresponding routing table
- Routing table association for public subnet
- Subnets: Two public subnets and two private subnets
- Servers : four servers stored in pairs in each private subnets
- Security Group 