**Udagram - Infrastructure as code Project**
---

This project is about deploying an application(Apache Web Server).

Deployed an instagram clone called "Udagram" using Terraform to provision the necessary infrastructures. I also created the architectural diagram to understand how resources are connected in the image below.
![](https://github.com/ibejalon/Terraformpractice/blob/master/Udagram/images/Udagram_architecture.jpeg)

#### To deploy the above resources in linux:
1. Create an EC2 instance on AWS if Terraform 0.12 version or higher is not installed on your PC
2. Check Terraform version `Terraform --version`
3. Configure AWS `aws configure` using access and secret keys
4. Clone this git repo using `git clone`(put my git)
5. Enter into the project directory `cd Terraformpractice`
6. Initialize terraform `terraform init`
7. View the structure of the infrastructure to be deployed using `terraform plan`
8. Create the resources using `terraform apply`

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

### File `vpc.tf`
The first resource defined is Udagram VPC `resource "aws_vpc" "udagram"`.
Within the VPC are the following resources:
- Public subnet1 in US- East-2a availability zone
 ```resource "aws_subnet" "udagram-public-1"```, `availability_zone = "us-east-2a"`
- Public subnet2 in US-East-2b availability zone 
```resource "aws_subnet" "udagram-public-2"```, `availability_zone = "us-east-2b"
- Private subnet1 in US-east-2a 
`resource "aws_subnet" "udagram-private-1"`, `availability_zone = "us-east-2a"`
- Private subnet2 in US-east-2b 
`resource "aws_subnet" "udagram-private-2"`, `availability_zone = "us-east-2a"`
#### Internet gateway for the the VPC
```
resource "aws_internet_gateway" "udagram-gw" {
  vpc_id = aws_vpc.udagram.id
  The internet gateway is the resource needed to connect the private cloud to the internet. The private cloud reffered is the VPC and all the resouces provisioned therein.
  ```
####  - Route tables associated with the internet gateway
  - Route association is for the association between the route table forpublic subnet 1 and 2. This route table association maps the route table with the internet gateway for ingress and egress traffic.
```
resource "aws_route_table_association" "udagram-public-1-a" {
  subnet_id      = aws_subnet.udagram-public-1.id
  route_table_id = aws_route_table.udagram-public.id
}


resource "aws_route_table_association" "udagram-public-2-a" {
  subnet_id      = aws_subnet.udagram-public-2.id
  route_table_id = aws_route_table.udagram-public.id
```
### File version.tf
The version.tf file dictates the terraform version for this script. For this infrastructure script works perfectly with terraform version 0.12 and above, earlier version may not work as intend.




### File `Compute.tf`
Here, the bastion host, instance type and ami are defined. The bastion references the public1 subnet and it allows ssh of the secuity group.
```
resource "aws_instance" "Bastion" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.udagram-public-1.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
```
### File `nat.tf`


### File `elb.tf`

### File `autoscaling.tf`

### File `securitygroup.tf`


### File `iam.tf`

### File `s3.tf`

### File `key.tf`

### File `provider.tf`

### File `versions.tf`
