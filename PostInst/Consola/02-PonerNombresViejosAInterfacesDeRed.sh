#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para re-escribir /etc/network/interfaceds con los nombres antiguos de las interfaces de red
#-----------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Configurando las interfaces de red...${FinColor}"
echo ""
echo "auto lo" > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "  allow-hotplug eth0" >> /etc/network/interfaces
echo "  iface eth0 inet dhcp" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

