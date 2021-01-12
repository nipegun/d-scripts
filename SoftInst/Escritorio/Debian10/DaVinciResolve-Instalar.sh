#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y preparar la compartición remota del escritorio en Debian 9
#------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

menu=(dialog --timeout 5 --checklist "Elección de la versión:" 22 76 16)
  opciones=(1 "DaVinci Resolve 16" on
            2 "DaVinci Resolve 17" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices

    do

      case $choice in

        1)
          echo ""
          echo -e "${ColorVerde}-----------------------------------------------${FinColor}"
          echo -e "${ColorVerde}Instalando y configurando DaVinci Resolve 16...${FinColor}"
          echo -e "${ColorVerde}-----------------------------------------------${FinColor}"
          echo ""

        ;;

        2)
          echo ""
          echo -e "${ColorVerde}-----------------------------------------------${FinColor}"
          echo -e "${ColorVerde}Instalando y configurando DaVinci Resolve 17...${FinColor}"
          echo -e "${ColorVerde}-----------------------------------------------${FinColor}"
          echo ""

        ;;

      esac

done

