#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------
#  Script de NiPeGun para instalar y configurar WireGuard
#----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando WireGuard...${FinColor}"
echo ""
echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
echo "Package: *" > /etc/apt/preferences.d/limit-unstable
echo "Pin: release a=unstable" >> /etc/apt/preferences.d/limit-unstable
echo "Pin-Priority: 90" >> /etc/apt/preferences.d/limit-unstable
apt-get -y update
apt-get -y install wireguard

