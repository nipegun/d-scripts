#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar
#---------------------------------------------------------------------------------------

CantArgsCorrectos=1
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [NombreDelMódulo]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 igb'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    apt-get -y update 2> /dev/null
    apt-get -y install dialog 2> /dev/null
    menu=(dialog --timeout 5 --checklist "¿En que versión de Debian quieres instalar xxx?:" 22 76 16)
      opciones=(1 "Debian  8" off
                2 "Debian  9" off
                3 "Debian 10" off
                4 "Debian 11" off)
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
            ;;

            2)
            ;;

            3)
            ;;

            4)
            ;;
        
          esac
        done
    fi

