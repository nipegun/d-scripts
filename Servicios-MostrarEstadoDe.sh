#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para mostrar el estado de un servicio
#-----------------------------------------------------------

CantArgsCorrectos=1
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [NombreDelServicio]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 apache2'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    systemctl status $1 -n50
    # journalctl -u $1.service -b
fi

