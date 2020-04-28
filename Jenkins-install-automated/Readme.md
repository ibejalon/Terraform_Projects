## Jenkins installation 

 I have automated Jenkins automation by doing the following:

* Declare AWS Key pair resources, keyname and Public key
* Define resources in instance
* Declare AWS variables in provider
* Script to setup and isntall Jenkins in script.sh which also declare where the bash interpreter is
* Execute the provisioner in Linux -"remote_exec"