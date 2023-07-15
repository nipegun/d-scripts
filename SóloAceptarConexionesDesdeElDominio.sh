#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para bloquear todas las IPs que acceden al sistema menos la que se indique
# ----------

cColorRojo="\033[1;31m"
cColorVerde="\033[1;32m"
cFinColor="\033[0m"

cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}Mal uso del script!${cFinColor}"
    echo ""
    echo -e "El uso correcto sería: $0 ${cColorVerde}[IPAPermitir]${cFinColor}""
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "$0 111.222.333.444"
    echo ""
    exit
  else
    getent hosts $1 | awk '{ print $1 }'
fi

