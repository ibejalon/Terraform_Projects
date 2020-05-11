# Implementing Best Practice for Infrastructure as Code Project

In a typical environment, testing is done in Dev environment before an application is deployed in prodution.To incorporate this best practice deployment approach, I created a dev and production environment with Modules for VPC, Bastion, and Jenkins Instance.

### How it works
Dev calls modules for Bastion, Jenkins-instance, and VPC from the `dev.tf` file which contains the details of the defined module such as:
* Source - directory of the module to be defined
* ENV - the dev environment
* Region - defined in `vars.tf`
* VPC_id - passed from the VPC module

Once this runs successfully in dev, `terraform init` `terraform plan` and `terraform apply` can now be applied to prod files.

### Modules
1. Bastion:  is the host that provide secure access to instances in the private and public subnets inside the virtual private cloud (VPC).The module contains scripts to define the instance (instance.tf), securitygroup.tf that allows ssh access to the instance, variable file that defines environment (Which is left blank because it will be passed either as Dev or Prod), AWS region, instance type, AMI

2. VPC: defines the VPC resource, environment(dev or prod) and availability zones which are passed in from the variable file(vars.tf), output file that displays IP address.(It is important to output the public subnet,private subnet and VPC so that Bastion and Jenkins Module will be able to use it because they referenced as VPC id)

3. Jenkins-instance: Cloud init and user data used to call the scripts that automate jenkins installation. Added EBS vol that will be mounted incase the Jenkins host crashes. 
