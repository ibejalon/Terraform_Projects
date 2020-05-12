**Udagram**
---

This project is about deploying an application(Apache Web Server) whose code (JavaScript and HTML) was stored in S3.

Deployed an instagram clone called "Udagram" using Terraform to provision the necessary infrastructures. I also created the architectural diagram to understand how resources are connected in the image below.
![](https://github.com/ibejalon/Terraformpractice/blob/master/Udagram/images/Udagram_architecture.jpeg)


The architecture has Public Subnets (for 2-way internet), Private Subnet(one-way internet),Load balancer, networking elements(internet and NAT gateways), Servers, routing tables.

### Project Requirements:

Server specs : Created a Launch Configuration for the application servers in order to deploy four servers, two located in each private subnet. The launch configuration was used by auto-scaling group.

Security Groups and Roles: Created an IAM Role because application archive is downloaded from S3 Bucket. Udagram Communicate via port :80 for inbound port. Out bound access is unlimited hence load balancer set to allow all public traffic (0.0.0.0/0) on port 80. 

My task is to deploy the application by creating the following  infrastructure:

- VPC: The private cloud environment needed to spin up resources for Udagram
- Availability Zones: Two availability zones created for failover
- Bastion Host : which runs on EC2 instance in the public subnet provides access to the private subnet.It is set up with a security group to allow SSH and egress traffic
- VPC NAT Gateway: lets private subnets route to the public
- Internet gateway with corresponding routing table
- Routing table association for public subnet
- Subnets: Two public subnets and two private subnets
- Servers : four servers stored in pairs in each private subnets from autoscaling group with minimum configuration of 4 instance
- Security Group 

## How is the Udagram repo structured?
I will explain the function of each folder below.
### Folder `vpc.tf`
