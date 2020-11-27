#!/bin/bash

URL="http://drivers.amd.com/drivers/linux/"

# 20.30
#
#Archivo="amdgpu-pro-20.30-1109583-ubuntu-18.04.tar.xz"
Archivo="amdgpu-pro-20.30-1109583-ubuntu-20.04.tar.xz"
# AMD Radeon™ RX 5700/5600/5500 Series Graphics
# AMD Radeon™ Pro WX-series
# AMD Radeon™ VII Series Graphics
# AMD Radeon™ Pro WX 9100
# AMD Radeon™ RX Vega Series Graphics
# AMD Radeon™ Pro WX 8200
# AMD Radeon™ Vega Frontier Edition
# AMD FirePro™ W9100
# AMD Radeon™ RX 550/560/570/580/590 Series Graphics
# AMD FirePro™ W8100
# AMD Radeon™ RX 460/470/480 Graphics
# AMD FirePro™ W7100
# AMD Radeon™ Pro Duo
# AMD FirePro™ W5100
# AMD Radeon™ R9 Fury/Fury X/Nano Graphics
# AMD FirePro™ W4300
# AMD Radeon™ R9 380/380X/390/390X Graphics
# AMD Radeon™ R9 285/290/290X Graphics
# AMD Radeon™ R9 360 Graphics


# 20.40
#
#Archivo="amdgpu-pro-20.40-1147287-ubuntu-18.04.tar.xz"
#Archivo="amdgpu-pro-20.40-1147286-ubuntu-20.04.tar.xz"
# AMD Radeon™ RX 5700/5600/5500 Series Graphics
# AMD Radeon™ Pro WX-series
# AMD Radeon™ VII Series Graphics
# AMD Radeon™ Pro WX 9100
# AMD Radeon™ RX Vega Series Graphics
# AMD Radeon™ Pro WX 8200
# AMD Radeon™ Vega Frontier Edition
# AMD FirePro™ W9100
# AMD Radeon™ RX 550/560/570/580/590 Series Graphics
# AMD FirePro™ W8100
# AMD Radeon™ RX 460/470/480 Graphics
# AMD FirePro™ W7100
# AMD Radeon™ Pro Duo
# AMD FirePro™ W5100
# AMD Radeon™ R9 Fury/Fury X/Nano Graphics
# AMD FirePro™ W4300
# AMD Radeon™ R9 380/380X/390/390X Graphics
# AMD Radeon™ R9 285/290/290X Graphics
# AMD Radeon™ R9 360 Graphics

amdgpu-uninstall -y

echo ""
echo "Quitando arquitectura i386"
echo ""
dpkg --remove-architecture i386
apt-get -y update

apt-get -y install wget
mkdir -p /root/paquetes/amdgpu-pro
rm -rf /root/paquetes/amdgpu-pro/*
wget --referer https://www.amd.com/es/support $URL$Archivo -O /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz
tar -xvf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz -C  /root/paquetes/amdgpu-pro/
rm -rf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz

echo ""
echo "Agregando arquitectura i386"
echo ""
dpkg --add-architecture i386
apt-get -y update

echo ""
echo "Listo para instalar..."
echo ""
