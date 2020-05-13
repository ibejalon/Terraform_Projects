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
I will explain the function of each folder (terraform file) .

### File `provider.tf`
Here, I stated AWS as the cloud provider for this project, and the region is defined in `vars.tf`.
```
provider "aws" {
  region = var.AWS_REGION
}
```

### File `vpc.tf`
This is where VPC for Udagram is defined 
```
resource "aws_vpc" "udagram"
```
Within the VPC are the following resources:
1. Public subnet1 in US- East-2a availability zone
 ```
 resource "aws_subnet" "udagram-public-1" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"
 ```
2. Public subnet2 in US-East-2b availability zone 
```
resource "aws_subnet" "udagram-public-2" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b
  ```
3. Private subnet1 in US-east-2a 
```
resource "aws_subnet" "udagram-private-1" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"
  ```
4. Private subnet2 in US-east-2b 
```
resource "aws_subnet" "udagram-private-2" {
  vpc_id                  = aws_vpc.udagram.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"
  ```

5. Internet gateway for the the VPC
The internet gateway is needed to connect the private cloud to the internet. The private cloud referred to is the Udagram VPC defined and all the resouces provisioned therein.
```
resource "aws_internet_gateway" "udagram-gw" {
  vpc_id = aws_vpc.udagram.id
  
  ```
6. Route tables associated with the internet gateway
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
```
terraform {
  required_version = ">= 0.12"
}
```

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
```
variable "AWS_ACCESS_KEY" {
}
variable "AWS_SECRET_KEY" {
}
variable "AWS_REGION" {
  default = "us-east-2"
}
```
 *Note: The secret and access keys will be used as input to `terraform.tfvars` which is hidden in `.gitignore` to prevent the keys from being pushed to this repo.So dont worry, my keys are save!*

### File `nat.tf`
This file provision five(5) resources that are needed to route outbound traffic from private subnets of the infrastructure through the public subnets to the internet gateway. The provisioned resources are:

1. ElasticIP                    
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
The elastic load balancer for the autoscaling group in the private subnets is provisioned with this script.
```
resource "aws_elb" "udagram-elb" {
  name            = "udagram-elb"
  subnets         = [aws_subnet.udagram-private-1.id, aws_subnet.udagram-private-2.id]
  security_groups = [aws_security_group.udagram-elb-securitygroup.id]
  ```
The autoscaling group is the set of servers that provides webservices to the public.Without it, the Udagram will not be accessible.
The elastic load balancer has a listener on port 80, health_check that runs every 2secs and timesout after 3secs if the health checks   fails. 

There is also connection draining time out of 400 seconds which is the max time for the load balancer to keep connections alive before reporting the instance as de-registered.

Cross zone loading balancing is also enabled for Elastic Load Balancers to ensure fault tolerance.That means, Udagram app must be up at all times even when one availabilty zone is down.
```
cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
```

### File `autoscaling.tf`
```
resource "aws_launch_configuration" "sample-launchconfig" 
```
The resource "aws_launch_configuration" "sample-launchconfig" is  the lunch profile for the autoscaling group. The group is deployed in the private subnets of the infrastructure and is not accessible to the public.
The autoscaling group is deployed across two availability zones for high availability and redundancy.
```
resource "aws_autoscaling_group" "sample-autoscaling" {
  name                      = "sample-autoscaling"
  vpc_zone_identifier       = [aws_subnet.udagram-private-1.id, aws_subnet.udagram-private-2.id]
  launch_configuration      = aws_launch_configuration.sample-launchconfig.name
  ```
  
### File `securitygroup.tf`
This a firewall script that dictates what connection is allowed to different resources within the VPC.

- Security group for the bastion: `resource "aws_security_group" "allow-ssh"`
The security group resource above is used to provide SSH connection (tcp port 22) to resources, in this case, the bastion host. with this security group applied to the bastion host, ssh connection from any host with the appropriate public key is allowed.

- Secuity group for servers in the private subnet
```
resource "aws_security_group" "myserver"
```
This is attached to the servers in the autoscaling group, it allows egress connection to any destination( i.e for general updates) but limits connection to port 22 and port 80 (used for http delivery).
- Security group for ELB
```
resource "aws_security_group" "udagram-elb-securitygroup" 
```
The above resource  attached to the elb (elastic load balancer), allows all egress (outbound) traffic but limits inboud traffic to port 80

### File `iam.tf`
This is simply defining administrator as the IAM group and two admins as users who have access to the S3-udagrambucket.

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


