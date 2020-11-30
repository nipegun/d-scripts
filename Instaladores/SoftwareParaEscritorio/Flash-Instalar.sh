#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------
#  Script de NiPeGun para instalar Flash en Firefox
#--------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo "-------------------------------------------------"
echo -e "${ColorVerde}Descargando e instalando flash...${FinColor}"
echo "-------------------------------------------------"
echo ""
echo "  Instalando el plugin de flash..."
echo ""
mkdir -p /root/Paquetes/FlashPlayer
cd /root/Paquetes/FlashPlayer
wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/flashplayer/flash_player_npapi_linux.x86_64.tar.gz
tar zxpvf flash_player_npapi_linux.x86_64.tar.gz
rm flash_player_npapi_linux.x86_64.tar.gz
cp libflashplayer.so /usr/lib/mozilla/plugins/
cp -r usr/* /usr

