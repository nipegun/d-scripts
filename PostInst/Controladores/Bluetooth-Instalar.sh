#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar controladores bluetooth en Debian
#
#  Instalación remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Controladores/Bluetooth-Instalar.sh | bash
#--------------------------------------------------------------------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

apt-get -y update 2> /dev/null
apt-get -y install dialog 2> /dev/null

menu=(dialog --timeout 5 --checklist "Elección del adaptador:" 22 76 16)
  opciones=(1 "Bluetoth Intel - Tarjeta Centrino 7260 (8087:07dc)" off
            2 "2" off
            3 "3" off
            4 "4" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${ColorVerde}Instalando controladores Bluetooth para la tarjeta Intel Centrino 7260...${FinColor}"
          echo ""
          apt-get update -y
          apt-get install -y firmware-iwlwifi blueman

        ;;

        2)
        ;;

        3)
        ;;

        4)
        ;;

      esac

done

    
