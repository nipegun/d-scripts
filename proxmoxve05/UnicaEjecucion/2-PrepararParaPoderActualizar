#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para preparar ProxmoxVE para que pueda ser actualizado por no-suscriptores 
#------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Deshabilitando el repositorio Enterprise...${FinColor}"
echo ""
cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
sed -i -e 's|deb https://enterprise.proxmox.com/debian/pve stretch pve-enterprise|# deb https://enterprise.proxmox.com/debian/pve stretch pve-enterprise|g' /etc/apt/sources.list.d/pve-enterprise.list

echo ""
echo -e "${ColorVerde}Agregando el repositorio para no-suscriptores...${FinColor}"
echo ""
echo "deb http://download.proxmox.com/debian/pve stretch pve-no-subscription" > /etc/apt/sources.list.d/pve-no-sub.list

echo ""
echo -e "${ColorVerde}Activando cambios en apt...${FinColor}"
echo ""
apt-get -y update

