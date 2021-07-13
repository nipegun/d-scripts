#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------
#  Script de NiPeGun para instalar los sensores de dispositivos en Debian
#--------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}  Instalando el paquete sensors...${FinColor}"
echo ""
apt-get -y update
apt-get -y install sensors

echo ""
echo -e "${ColorVerde}  Instalando el paquete hddtemp...${FinColor}"
echo ""
apt-get -y update
apt-get -y install hddtemp

echo ""
echo -e "${ColorVerde}  Detectando los sensores...${FinColor}"
echo ""
/usr/bin/yes YES | /usr/sbin/sensors-detect

echo ""
echo -e "${ColorVerde}  Activando el módulo del kernel...${FinColor}"
echo ""
/etc/init.d/kmod start

