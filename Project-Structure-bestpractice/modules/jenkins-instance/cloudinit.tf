# JENKINS-INIT

data "template_file" "init-script" {
  template = file("../modules/jenkins-instance/scripts/init.cfg")
  vars = {
    REGION = var.AWS_REGION
  }
}

data "template_file" "jenkins-init" {
  template = file("../modules/jenkins-instance/scripts/jenkins-init.sh")
  vars = {
    DEVICE            = var.INSTANCE_DEVICE_NAME
    TERRAFORM_VERSION = var.TERRAFORM_VERSION
  }
}

data "template_cloudinit_config" "cloudinit-script" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.jenkins-init.rendered
  }
}

