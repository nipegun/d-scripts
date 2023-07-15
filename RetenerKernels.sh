#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para retener sólo los úlltimos kernels indicados
# ----------

cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [ÚltimosKernelsARetener]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 2'
    
    echo ""
    exit
  else
    apt-get -y install byobu
    purge-old-kernels --keep $1
fi

