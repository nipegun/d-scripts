#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar las tablas de reglas de NFTables
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorVerde}Mostrando la tabla arp...${cFinColor}"
nft list ruleset arp
echo ""

echo ""
echo -e "${cColorVerde}Mostrando la tabla bridge...${cFinColor}"
nft list ruleset bridge
echo ""

echo ""
echo -e "${cColorVerde}Mostrando la tabla inet...${cFinColor}"
nft list ruleset inet
echo ""

echo ""
echo -e "${cColorVerde}Mostrando la tabla ip...${cFinColor}"
nft list ruleset ip
echo ""

echo ""
echo -e "${cColorVerde}Mostrando la tabla ip6...${cFinColor}"
nft list ruleset ip6
echo ""

