## A sample Infrastructure as code project to provision a VPC and NAT

The architecture of the Infrastructure is in the 'image folder' wherein the script for all the 
resources created are listed in the named folders found in this repository.

In this case, I have created a VPC with 3 public subnets and 3 private subnets.

**The following resources are also created:**

- An internet gateway attached to the VPC to allow internet communication
- Route table 
- Route table Association in each of the three public subnets to enable outside internet connectivity in the VPC
- Route table Association in each of the three private subnets that allow the private subnets to receive internet connection from the Public subnet
- Elastic IP