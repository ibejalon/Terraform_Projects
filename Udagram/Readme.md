**Infrastructure as Code Using Terraform**
---

This project is about deploying an application(Apache Web Server) whose code (JavaScript and HTML) was stored in S3

To deploy application with necessary resources into its infrastructure for a fictitious Instagram clone “Udagram” where developers have pushed codes in an S3 bucket in AWS. There are two parts to the project: 

1. Created an architectural diagram with lucid chart for visual aid to understand what resources to be created 
2. Created a matching Terraform script

 The architecture has Public Subnets (for 2-way internet), Private Subnet(one-way internet),Load balancer, networking elements(internet and NAT gateways), Servers, routing tables.

### Project Requirements:

Server specs : Created a Launch Configuration for the application servers in order to deploy four servers, two located in each private subnet. The launch configuration was used by auto-scaling group.

Security Groups and Roles: Created an IAM Role because application archive is downloaded from S3 Bucket. Udagram Communicate via port :80 for inbound port. Out bound access is unlimited hence load balancer set to allow all public traffic (0.0.0.0/0) on port 80. 

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