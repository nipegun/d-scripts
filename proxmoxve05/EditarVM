#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA EDITAR EL ARCHIVO DE CONFIGURACIÓN DE UNA VM
#-----------------------------------------------------------------------

EXPECTED_ARGS=1
E_BADARGS=65

ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

FechaDeExp=$(date +A%YM%mD%d@%T)

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "edvm ${ColorArgumentos}[IDDeLaVM]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "edvm 101"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $E_BADARGS
  else
    nano /etc/pve/qemu-server/$1.conf
fi

