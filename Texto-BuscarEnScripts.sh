#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para encontrar una cadena específica dentro de los archivos de script
# ----------

ArgumentosEsperados=1
ArgumentosInsuficientes=65

if [ $# -ne $ArgumentosEsperados ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 texto"
    echo ""
    echo "Ejemplo:"
    echo "&0 Perro"
    echo "##################################################"
    echo ""
    exit $ArgumentosInsuficientes
  else
    echo ""
    grep -rnw --color -e $1 /root/scripts/
    echo ""
fi
