#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------
#  Script de NiPeGun para instalar el servidor gaming de Minecraft mcserver
#----------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando el dibujador del mapa...${FinColor}"
echo ""

apt-get -y update > /dev/null
apt-get -y install python3-pil python3-dev python3-numpy git
mkdir /root/git
cd /root/git
git clone git://github.com/overviewer/Minecraft-Overviewer.git
cd Minecraft-Overviewer
python3 setup.py build
ln -s /root/git/Minecraft-Overviewer/overviewer.py /usr/local/bin/mcoverviewer

