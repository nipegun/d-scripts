#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para MOSTRAR EL CONTENIDO DE UN PAQUETE DE REPOSITORIO
# ----------


cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [NombreDelPaquete]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 firmware-atheros'
    
    echo ""
    exit
  else
    apt-get -y update

    echo ""
    echo "--------------------------------------"
    echo "  Mostrando el contenido del paquete"
    echo "  $1"
    echo "--------------------------------------"
    echo ""
    apt-cache show $1
fi

