#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para ejecutar un comando como otro usuario
# ----------

cCantArgumEsperados=2


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    
    echo "  Mal uso del script."
    echo ""
    echo "  El uso correcto sería:"
    echo '  $0 [Usuario] ["Comando"]'
    echo ""
    echo "  Ejemplo:"
    echo "  $0 nico ls -n ~"
    
    echo ""
    exit
  else
    runuser -l $1 -c "$2"
fi

