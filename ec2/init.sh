#! /bin/bash

yum update

echo "Installing Nginx"
yum install nginx
systemctl enable nginx
systemctl start nginx

echo "Installing NodeExporter"
mkdir /home/ubuntu/node_exporter
cd /home/ubuntu/node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar node_exporter-1.2.2.linux-amd64.tar.gz
cd node_exporter-1.2.2.linux-amd64
./node_exporter &
echo "Changing Hostname"
hostname "$machine_${count.index+1}"
echo "$machine_${count.index+1}" > /etc/hostname
