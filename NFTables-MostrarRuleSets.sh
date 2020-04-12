#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para mostrar las tablas de reglas de NFTables
#-------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Mostrando la tabla arp...${FinColor}"
nft list ruleset arp
echo ""

echo ""
echo -e "${ColorVerde}Mostrando la tabla bridge...${FinColor}"
nft list ruleset bridge
echo ""

echo ""
echo -e "${ColorVerde}Mostrando la tabla inet...${FinColor}"
nft list ruleset inet
echo ""

echo ""
echo -e "${ColorVerde}Mostrando la tabla ip...${FinColor}"
nft list ruleset ip
echo ""

echo ""
echo -e "${ColorVerde}Mostrando la tabla ip6...${FinColor}"
nft list ruleset ip6
echo ""

