#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Jitsi en Debian 10
#-------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Desinstalando jitsi-meet...${FinColor}"
echo ""

apt-get -y purge jitsi-meet
apt-get -y purge jicofo
apt-get -y purge jitsi*
apt-get -y purge prosody
apt-get -y autoremove
rm /etc/jitsi -R 2> /dev/null
rm /etc/prosody -R 2> /dev/null
rm -f /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
apt-get -y update > /dev/null

