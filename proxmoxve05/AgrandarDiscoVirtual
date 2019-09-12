#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para aumentar el tamaño de un disco de una VM
#-------------------------------------------------------------------

EXPECTED_ARGS=3
E_BADARGS=65

ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "AgrandarDiscoVirtual ${ColorArgumentos}[IDDeLaVM] [PuertoDelDisco] [GigasASumar]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "AgrandarDiscoVirtual 206 sata1 5"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $E_BADARGS
  else
    qm resize $1 $2 +$3G
fi

