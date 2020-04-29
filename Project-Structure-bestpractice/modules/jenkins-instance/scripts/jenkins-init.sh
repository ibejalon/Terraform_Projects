#!/bin/bash

vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi
mkdir -p /var/jenkins_home
echo '/dev/data/volume1 /var/jenkins_home ext4 defaults 0 0' >> /etc/fstab
mount /var/jenkins_home

# install nginx for reverse proxy
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
apt-get update -y
apt-get install nginx -y
systemctl start nginx
systemctl enable nginx

# install pip
wget -q https://bootstrap.pypa.io/get-pip.py
apt install python-pip
pip install --upgrade pip
pip install pylint

# Create python virtualenv & source it
# source ~/.devops/bin/activate
apt-get install python3-venv -y
python3 -m venv ~/.devops
source ~/.devops/bin/activate

# install node
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
apt-get install nodejs
npm install -g dockerlint

# install awscli
pip install awscli

# install docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt list --upgradable
sudo apt-get install -y docker-ce
usermod -aG docker ubuntu
docker pull hadolint/hadolint
systemctl restart docker

# run jenkins
sudo chown -R 1000:1000 /var/jenkins_home
sudo docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -d --name jenkins jenkins/jenkins:lts

# show endpoint
echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -s ifconfig.co)':8080'