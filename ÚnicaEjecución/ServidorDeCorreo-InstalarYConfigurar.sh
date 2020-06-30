#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor de correo electrónico
#----------------------------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

apt-get -y update 2> /dev/null
apt-get -y install dialog 2> /dev/null

menu=(dialog --timeout 5 --checklist "Elige la versión de Debian:" 22 76 16)
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
          apt-get -y install exim
        ;;

        4)

        ;;

      esac

done

