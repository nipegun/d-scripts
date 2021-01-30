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
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación del plugin de navegador para OBS Studio...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo ""

apt-get -y install curl wget
UltVers=$(curl -s https://github.curl https://github.com/bazukas/obs-linuxbrowser/releases/latest | cut -d'"' -f2 | cut -d'/' -f8)
Archivo=$(curl -s https://github.com/bazukas/obs-linuxbrowser/releases/tag/$UltVers | grep tgz | cut -d'"' -f2 | grep tgz)
mkdir -p /root/paquetes/obs-linuxbrowser
cd /root/paquetes/obs-linuxbrowser
rm -rf /root/paquetes/obs-linuxbrowser/*
wget --no-check-certificate https://github.com$Archivo
find /root/paquetes/obs-linuxbrowser/ -type f -name "*.tgz" -exec mv {} /root/paquetes/obs-linuxbrowser/$UltVers.tgz \;
tar zxvf /root/paquetes/obs-linuxbrowser/$UltVers.tgz
mkdir -p /root/.config/obs-studio/plugins/
cp /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/ /root/.config/obs-studio/plugins/


