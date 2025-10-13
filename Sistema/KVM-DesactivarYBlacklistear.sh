#!/bin/bash

sudo systemctl stop libvirtd
sudo systemctl stop qemu-kvm
sudo rmmod kvm_intel
sudo rmmod kvm_amd
sudo rmmod kvm
echo "blacklist kvm_intel" | sudo tee -a /etc/modprobe.d/blacklist-kvm-con-vbox.conf
echo "blacklist kvm_amd"   | sudo tee -a /etc/modprobe.d/blacklist-kvm-con-vbox.conf
echo "blacklist kvm"       | sudo tee -a /etc/modprobe.d/blacklist-kvm-con-vbox.conf
sudo update-initramfs -u -k all
