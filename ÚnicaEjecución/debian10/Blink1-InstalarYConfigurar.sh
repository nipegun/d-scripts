#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar la luz USB Blink1
#------------------------------------------------------------------

apt-get -y update && apt-get -y install git build-essential pkg-config libusb-1.0-0-dev

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Preparando el sistema para funcionar con Blink1...${FinColor}"
mkdir -p /root/git/
cd /root/git/
git clone https://github.com/todbot/blink1-tool.git
cd blink1-tool
make

