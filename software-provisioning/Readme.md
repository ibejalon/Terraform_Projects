## Used Provisioner in shell scripting to install Nginx
There are different ways to install Software on Terraform such as through Ansible, Chef or puppet.

In this case, I used Provisioner to do the following:

* Declare AWS Key pair resources, keyname and Public key
* Define resources in instance
* Declare AWS variables in provider
* Script to setup and isntall Nginx in script.sh which also declare where the bash interpreter is
* Execute the provisioner in Linux -"remote_exec"