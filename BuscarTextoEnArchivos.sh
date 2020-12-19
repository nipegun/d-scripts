#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para buscar una cadena específica dentro de archivos de una ubicación dada
#------------------------------------------------------------------------------------------------

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 ruta texto"
    echo ""
    echo "Ejemplo:"
    echo "&0 /etc/ Perro"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    echo ""
    grep -rnw --color $1 -e $2
    echo ""
fi

