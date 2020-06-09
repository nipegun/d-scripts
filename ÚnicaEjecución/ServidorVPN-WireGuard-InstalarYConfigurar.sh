#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------
#  Script de NiPeGun para instalar y configurar WireGuard
#----------------------------------------------------------

CantArgsCorrectos=1
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [x]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 x'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    apt-get -y update 2> /dev/null
    apt-get -y install dialog 2> /dev/null
    menu=(dialog --timeout 5 --checklist "¿En que versión de Debian quieres instalar xxx?:" 22 76 16)
      opciones=(1 "Debian  8, Jessie" off
                2 "Debian  9, Stretch" off
                3 "Debian 10, Buster" off
                4 "Debian 11, Bullseye" off)
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo -e "${ColorVerde}Script para Debian 8 (Jessie) todavía no disponible.${FinColor}"
              echo ""
            ;;

            2)
              echo ""
              echo -e "${ColorVerde}Script para Debian 9 (Stretch) todavía no disponible.${FinColor}"
              echo ""
            ;;

            3)
              echo ""
              echo -e "${ColorVerde}Instalando WireGuard en Debian 10 (Buster)...${FinColor}"
              echo ""
              echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
              echo "Package: *" > /etc/apt/preferences.d/limit-unstable
              echo "Pin: release a=unstable" >> /etc/apt/preferences.d/limit-unstable
              echo "Pin-Priority: 90" >> /etc/apt/preferences.d/limit-unstable
              apt-get -y update
              apt-get -y install wireguard
            ;;

            4)
              echo ""
              echo -e "${ColorVerde}Script para Debian 11 (Bullseye) todavía no disponible.${FinColor}"
              echo ""
            ;;
        
          esac
        done
    fi

