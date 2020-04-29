output "bastion_pub_ip" {
  value = "${module.bastion.bastion-ip}"
}

output "jenkins-ip" {
  value = "${module.jenkins.jenkins-ip}"
}