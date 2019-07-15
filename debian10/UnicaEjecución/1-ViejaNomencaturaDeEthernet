#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para poner los nombres de las interfces de red a la nomenclatura usada en Debian 8
#--------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Cambiando el nombre de las interfaces de red...${FinColor}"
echo ""
sed -i -e 's|GRUB_CMDLINE_LINUX=""|GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"|g' /etc/default/grub

echo ""
echo -e "${ColorVerde}Acortando el tiempo de espera de grub...${FinColor}"
echo ""
sed -i -e "s|GRUB_TIMEOUT=5|GRUB_TIMEOUT=1|g" /etc/default/grub

echo ""
echo -e "${ColorVerde}Actualizando grub...${FinColor}"
echo ""
update-grub

