#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------
#  Script de NiPeGun para instalar Skype en Debian 9
#-----------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando Skype...${FinColor}"
apt-get -y update
apt-get -y install gdebi wget
mkdir /root/paquetes
cd /root/paquetes
wget https://go.skype.com/skypeforlinux-64.deb
gdebi skypeforlinux-64.deb

