#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------
#  Script de NiPeGun para agregar un usuario específico a los buzones
#----------------------------------------------------------------------

CantArgsEsperados=1
ArgsInsuficientes=65

ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "QuéInstalóElPaquete ${ColorArgumentos}[NombreDelPaquete]${FinColor}"
    echo ""
    echo "Ejemplo 1:"
    echo ' QuéInstalóElPaquete plexmediaserver'
    echo ""
    echo "Ejemplo 2:"
    echo ' QuéInstalóElPaquete mumble'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    dpkg -L $1
    echo ""
fi

