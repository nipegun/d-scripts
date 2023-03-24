#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para mostrar información sobre la tarjeta gráfica
# ----------

vColorVerde="\033[1;32m"
vFinColor="\033[0m"

echo ""
echo -e "${vColorVerde}  Mostrando información sobre la/las tarjeta gráfica/s...${vFinColor}"
echo ""

lspci -kknn -d ::300
echo ""

