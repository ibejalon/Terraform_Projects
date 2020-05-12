**Udagram - Infrastructure as code Project**
---

This project is about deploying an application(Apache Web Server).

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
The first resource defined is Udagram VPC `resource "aws_vpc" "udagram"`.
Within the VPC are the following resources:
- Public subnet1 in US- East-2a availability zone ```resource "aws_subnet" "udagram-public-1"```, `availability_zone = "us-east-2a"`
- Public subnet2 in US-East-2b availability zone ```resource "aws_subnet" "udagram-public-2"```, `availability_zone = "us-east-2b"`
- Private subnet1 in US-east-2a `resource "aws_subnet" "udagram-private-1"`, `availability_zone = "us-east-2a"`
- Private subnet2 in US-east-2b `resource "aws_subnet" "udagram-private-2"`, `availability_zone = "us-east-2a"`
- Internet gateway that references the VPC
```
resource "aws_internet_gateway" "udagram-gw" {
  vpc_id = aws_vpc.udagram.id
  ```
  - Route tables associated with the internet gateway
  - Route association is for the association between the route table and public subnet 1 and 2
```
resource "aws_route_table_association" "udagram-public-1-a" {
  subnet_id      = aws_subnet.udagram-public-1.id
  route_table_id = aws_route_table.udagram-public.id
}

resource "aws_route_table_association" "udagram-public-2-a" {
  subnet_id      = aws_subnet.udagram-public-2.id
  route_table_id = aws_route_table.udagram-public.id
```
#### To deploy the above resources in linux:
1. Create an EC2 instance on AWS
2. Use instance above to connect to Ubuntu
3. Enter into the project directory `cd Terraformpractice`
4. Pull the code from local repo to the linux envrionment `Git pull origin master`
5. Initialize terraform `terraform init`
6. Create resources `terrform apply`

### Folder `Compute.tf`
Here, the bastion host, instance type and ami are defined. The bastion references the public1 subnet and it allows ssh of the secuity group.
```
resource "aws_instance" "Bastion" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.udagram-public-1.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
```
### Folder `nat.tf`


### Folder `elb.tf`

### Folder `autoscaling.tf`

### Folder `securitygroup.tf`


### Folder `iam.tf`

### Folder `s3.tf`

### Folder `key.tf`

### Folder `provider.tf`

### Folder `versions.tf`
