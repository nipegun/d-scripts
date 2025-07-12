#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para vaciar las reglas de NFTables
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorVerde}  Vaciando las reglas de NFTables...${cFinColor}"
nft flush ruleset
echo ""

# También se puede hacer por familia de reglas
# nft flush ruleset arp
# nft flush ruleset bridge
# nft flush ruleset inet
# nft flush ruleset ip
# nft flush ruleset ip6 

