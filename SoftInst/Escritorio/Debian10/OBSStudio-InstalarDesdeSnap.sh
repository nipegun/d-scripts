#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para instalar y configurar OBS Studio
#-----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}------------------------${FinColor}"
echo -e "${ColorVerde}Instalando OBS Studio...${FinColor}"
echo -e "${ColorVerde}------------------------${FinColor}"
echo ""
apt-get -y install build-essential
apt-get -y install checkinstall
apt-get -y install cmake
apt-get -y install git
apt-get -y install libmbedtls-dev
apt-get -y install libasound2-dev
apt-get -y install libavcodec-dev
apt-get -y install libavdevice-dev
apt-get -y install libavfilter-dev
apt-get -y install libavformat-dev
apt-get -y install libavutil-dev
apt-get -y install libcurl4-openssl-dev
apt-get -y install libfdk-aac-dev
apt-get -y install libfontconfig-dev
apt-get -y install libfreetype6-dev
apt-get -y install libgl1-mesa-dev
apt-get -y install libjack-jackd2-dev
apt-get -y install libjansson-dev
apt-get -y install libluajit-5.1-dev
apt-get -y install libpulse-dev
apt-get -y install libqt5x11extras5-dev
apt-get -y install libspeexdsp-dev
apt-get -y install libswresample-dev
apt-get -y install libswscale-dev
apt-get -y install libudev-dev
apt-get -y install libv4l-dev
apt-get -y install libvlc-dev
apt-get -y install libx11-dev
apt-get -y install libx264-dev
apt-get -y install libxcb-shm0-dev
apt-get -y install libxcb-xinerama0-dev
apt-get -y install libxcomposite-dev
apt-get -y install libxinerama-dev
apt-get -y install pkg-config
apt-get -y install python3-dev
apt-get -y install qtbase5-dev
apt-get -y install libqt5svg5-dev
apt-get -y install swig
apt-get -y install libxcb-randr0-dev
apt-get -y install libxcb-xfixes0-dev
apt-get -y install libx11-xcb-dev
apt-get -y install libxcb1-dev
apt-get -y install libxss-dev

wget https://cdn-fastly.obsproject.com/downloads/cef_binary_3770_linux64.tar.bz2
tar -xjf ./cef_binary_3770_linux64.tar.bz2
git clone --recursive https://github.com/obsproject/obs-studio.git
cd obs-studio
mkdir build && cd build
cmake -DUNIX_STRUCTURE=1 -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_BROWSER=ON -DCEF_ROOT_DIR="../../cef_binary_3770_linux64" ..
make -j4
sudo checkinstall --default --pkgname=obs-studio --fstrans=no --backup=no --pkgversion="$(date +%Y%m%d)-git" --deldoc=yes

