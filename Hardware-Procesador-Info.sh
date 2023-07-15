#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar información sobre el/los procesador/es
# ----------

cColorVerde="\033[1;32m"
ccFinColor="\033[0m"

echo ""
echo -e "${cColorVerde}  Mostrando información sobre el procesador...${cFinColor}"
echo ""
echo "Cantidad de núcleos de proceso disponibles en el sistema:"
echo ""
grep -c processor /proc/cpuinfo
echo ""
echo "A continuación se muestra la información respectiva"
echo ""
cat /proc/cpuinfo

