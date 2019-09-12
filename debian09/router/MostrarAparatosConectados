#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  Script de NiPeGun para ver equipos conectados al router Debian
#------------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

echo ""
echo -e "${ColorVerde}Usando dhcp-lease-list para mostrar equipos...${FinColor}"
echo ""
dhcp-lease-list --all

echo ""
echo -e "${ColorVerde}Usando arp-scan para mostrar equipos...${FinColor}"
echo ""
interfaz=$(sed -n 's|INTERFACESv4="\(.*\)"|\1|p' /etc/default/isc-dhcp-server)
arp-scan --interface=$interfaz --localnet

