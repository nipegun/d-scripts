#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.


vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

vCantArgsCorrectos=2
vArgsInsuficientes=65

if [ $# -ne $vCantArgsCorrectos ]
  then
    echo ""
    echo ""
    echo -e "${vColorRojo}  Mal uso del script.${vFinColor}"
    echo ""
    echo -e "${vColorRojo}  El uso correcto sería: ${vFinColor}"
    echo "    $0 [Argumento1] [Argumento2]"
    echo ""
    echo "  Ejemplo:"
    echo '    $0 "/etc/pepe/" "pepe.conf"'
    echo ""
    exit $vArgsInsuficientes
  else
    echo ""
    echo ""
    echo ""
    cat $1$2
fi

