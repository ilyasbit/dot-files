#!/bin/bash

ipaddress=$1
gateway=$2
hostname=$3
publickeyFile=$4

sudo apt update
sudo apt install jq nano curl wget -y

#install yq from github
VERSION=v4.2.0
BINARY=yq_linux_amd64

#check if yq is installed
if [ ! -x "$(command -v yq)" ]; then
  wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&
    chmod +x /usr/bin/yq
fi

#list all the network interfaces
ip a
#wait for user to select the network interface
read -p "Enter the network interface name: " interface
#configure the network interface using yq on netplan configuration file
yq eval -i ".network.ethernets.$interface.dhcp4=false" /etc/netplan/00-installer-config.yaml
yq eval -i ".network.ethernets.$interface.addresses = [\"${ipaddress}/24\"]" -i /etc/netplan/00-installer-config.yaml
yq eval -i ".network.ethernets.$interface.routes = [{\"to\": \"default\", \"via\": \"$gateway\", \"metric\": 0}]" -i /etc/netplan/00-installer-config.yaml
yq eval -i ".network.ethernets.$interface.nameservers.addresses = [\"8.8.8.8\"]" -i /etc/netplan/00-installer-config.yaml
yq eval -i ".network.ethernets.$interface.optional=true" -i /etc/netplan/00-installer-config.yaml
#set file permissions to 600
chmod 600 /etc/netplan/00-installer-config.yaml
#apply the network configuration
sudo netplan apply
oldhostname=$(hostname)
#set the hostname
sudo hostnamectl set-hostname $hostname
#add the hostname to /etc/hosts file replacing the old hostname
sudo sed -i "s/$oldhostname/$hostname/g" /etc/hosts

#add the public key to the authorized_keys file on root user
sudo mkdir -p /root/.ssh
#echo "" >/root/.ssh/authorized_keys
#cat $publicKeyFile | tee /root/.ssh/authorized_keys
