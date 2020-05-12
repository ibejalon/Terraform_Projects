**Udagram - Infrastructure as code Project**
---

This project is about deploying an application(Apache Web Server).

Deployed an instagram clone called "Udagram" using Terraform to provision the necessary infrastructures. I also created the architectural diagram to understand how resources are connected in the image below.
![](https://github.com/ibejalon/Terraformpractice/blob/master/Udagram/images/Udagram_architecture.jpeg)

#### To deploy the above resources in linux:
1. Create an EC2 instance on AWS if Terraform 0.12 version or higher is not installed on your PC
2. Check Terraform version `Terraform --version`
3. Configure AWS with access and secret keys `aws configure`
4. Clone repo using `git clone https://github.com/ibejalon/Terraformpractice.git`
5. Enter into the project directory `cd Terraformpractice`
6. Initialize terraform `terraform init`
7. View the structure of the infrastructure to be deployed using `terraform plan`
8. Create the resources using `terraform apply`

### Overview of the resources
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

### File `provider.tf`
Here, I stated AWS as the cloud provider for this project, and the region is defined in `vars.tf`.
```
provider "aws" {
  region = var.AWS_REGION
}
```

### File `vpc.tf`
This is where Udagram VPC is defined `resource "aws_vpc" "udagram"`.
Within the VPC are the following resources:
- Public subnet1 in US- East-2a availability zone
 ```resource "aws_subnet" "udagram-public-1"```, `availability_zone = "us-east-2a"`
- Public subnet2 in US-East-2b availability zone 
```resource "aws_subnet" "udagram-public-2"```, `availability_zone = "us-east-2b"
- Private subnet1 in US-east-2a 
`resource "aws_subnet" "udagram-private-1"`, `availability_zone = "us-east-2a"`
- Private subnet2 in US-east-2b 
`resource "aws_subnet" "udagram-private-2"`, `availability_zone = "us-east-2a"`
#### - Internet gateway for the the VPC
The internet gateway is needed to connect the private cloud to the internet. The private cloud reffered is the Udagram VPC defined and all the resouces provisioned therein.
```
resource "aws_internet_gateway" "udagram-gw" {
  vpc_id = aws_vpc.udagram.id
  
  ```
####  - Route tables associated with the internet gateway
Route association is for the association between the route table for public subnet 1 and 2. This route table association maps the route table with the internet gateway for ingress and egress traffic.
```
resource "aws_route_table_association" "udagram-public-1-a" {
  subnet_id      = aws_subnet.udagram-public-1.id
  route_table_id = aws_route_table.udagram-public.id
}
resource "aws_route_table_association" "udagram-public-2-a" {
  subnet_id      = aws_subnet.udagram-public-2.id
  route_table_id = aws_route_table.udagram-public.id
```
### File `version.tf`
The `version.tf` file dictates the terraform version for this script. The infrastructure script supports terraform version 0.12 and above, earlier version may not work as intend.


### File `Compute.tf`
Here, the bastion host, instance type and ami are defined. The bastion references the public1 subnet and it allows ssh of the security group.
```
resource "aws_instance" "Bastion" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.udagram-public-1.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
```
### File `vars.tf`
This is the variable file where AWS access key, secret key, region, public key, and AMI are defined.
 
 *Note: the secret and access keys will be used as input to `terraform.tfvars` which is hidden in `.gitignore` to prevent the keys from being pushed to this repo.So dont worry, my keys are save!*

### File `nat.tf`
This file provision five(5) resources that are needed to route outbound traffic from private subnets of the infrastructure through the public subnets to the internet gateway. The provisioned resources are:
1. ElasticIP  `nat` which provision an EIP exernal IP a reserved public IP 
```
resource "aws_eip" "nat" {
  vpc = true
}
```
2. NAT gateway  `nat-gw`
The network address translation gateway is needed to translate private IP addresses to publicly available IP addresses vice versa
```
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.udagram-public-1.id
  depends_on    = [aws_internet_gateway.udagram-gw]
}
```
3. Route table `udagram-private`
This is used by NAT gateway. It forwards any unknown addresses(0.0.0.0/0) to an associated resources.
```
resource "aws_route_table" "udagram-private" {
  vpc_id = aws_vpc.udagram.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  ```
The other resources provisioned are route associations for the private subnets

### File `elb.tf`

### File `autoscaling.tf`
### File `securitygroup.tf`
### File `iam.tf`

### File `s3.tf`
Here, storage resource is defined and has a private access because the application archive is stored here and it does not need to be accessed by the public. 
```
resource "aws_s3_bucket" "udagram" {
  bucket = "udagram-asdf1234"
  acl    = "private"

  tags = {
    Name = "udagram-asdf1234"
```

### File `key.tf` 
The key pair is defined here which is needed when configuring aws in linux
```
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
```
 *Note: The key pair is stored in `.gitgnore` so it won't be publicly available in this repo*


