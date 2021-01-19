#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------
#  Script de NiPeGun para actualizar Debian
#--------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}---------------------------------${FinColor}"
echo -e "${ColorVerde}Actualizando sistema operativo...${FinColor}"
echo -e "${ColorVerde}---------------------------------${FinColor}"
echo ""

echo ""
echo -e "${ColorVerde}Ejecutando apt-get update...${FinColor}"
echo ""
apt-get -y update

echo ""
echo -e "${ColorVerde}Ejecutando apt-get -y upgrade...${FinColor}"
echo ""
apt-get -y upgrade

echo ""
echo -e "${ColorVerde}Ejecutando apt-get -y dist-upgrade...${FinColor}"
echo ""
apt-get -y dist-upgrade

echo ""
echo -e "${ColorVerde}Ejecutando apt-get -y autoremove...${FinColor}"
echo ""
apt-get -y autoremove

echo ""
echo -e "${ColorVerde}------------------------------${FinColor}"
echo -e "${ColorVerde}Sistema operativo actualizado.${FinColor}"
echo -e "${ColorVerde}------------------------------${FinColor}"
echo ""

