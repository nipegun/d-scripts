#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para poner recursivamente todas las extensiones en minúsculas de todos los archivos de una ubicación dada
#-------------------------------------------------------------------------------------------------------------------------------

ArgumentosEsperados=1
ArgumentosInsuficientes=65

if [ $# -ne $ArgumentosEsperados ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [Ubicación]"
    echo ""
    echo "Ejemplo:"
    echo "$0 /home/pepe"
    echo "##################################################"
    echo ""
    exit $ArgumentosInsuficientes
  else
    echo ""
    find $1 -type f -exec sh -c 'a=$(echo "$0" | sed -r "s/([^.]*)\$/\L\1/"); [ "$a" != "$0" ] && mv "$0" "$a" ' {} \;
    echo ""
fi

