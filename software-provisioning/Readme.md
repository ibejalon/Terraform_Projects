## Used Provisioner in shell scripting to install Nginx

In this module, I practiced using Provisioner to do the following:

* Declare AWS Key pair resources, keyname and Public key in vars.tf
* Define resources in instance.tf
* Declare AWS variables in provider.tf
* Script to setup and install Nginx in script.sh which also declare where the bash interpreter is
* Execute the provisioner in Linux -"remote_exec"
