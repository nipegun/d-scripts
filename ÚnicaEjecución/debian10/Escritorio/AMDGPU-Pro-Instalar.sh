#!/bin/bash

URL="http://drivers.amd.com/drivers/linux/"
Archivo="amdgpu-pro-20.30-1109583-ubuntu-20.04.tar.xz"

apt-get -y update
apt-get -y install wget
mkdir -p /root/paquetes/amdgpu-pro
wget --referer https://www.amd.com/es/support $URL$Archivo -O /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz
tar -xvf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz -C  /root/paquetes/amdgpu-pro/
/usr/bin/amdgpu-uninstall
/usr/bin/amdgpu-pro-uninstall
