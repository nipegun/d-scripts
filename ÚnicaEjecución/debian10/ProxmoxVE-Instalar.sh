#!/bin/bash

apt-get -y update
apt-get -y install wget
echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/ProxmoxVE.list
wget http://download.proxmox.com/debian/proxmomx-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmomx-ve-release-6.x.gpg
apt-get -y update
apt-get -y install proxmox-ve
rm -rf /etc/apt/sources.list.d/pve-enterprise.list 
cp /etc/network/interfaces /etc/network/interfaces.bak
apt-get -y update


