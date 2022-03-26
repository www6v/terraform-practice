#! /bin/bash

yum install java-1.8.0-openjdk* -y

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install jenkins -y

chmod -R 777 /var/lib/jenkins
chmod -R 777 /var/cache/jenkins
chmod -R 777 /var/log/jenkins

systemctl start jenkins
systemctl enable jenkins
