#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para instalar un entorno gráfico en ProxmoxVE
#-------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Actualizando el sistema operativo...${FinColor}"
echo ""
apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoremove

menu=(dialog --timeout 5 --checklist "Elección de escritorio:" 22 76 16)
    opciones=(1 "Cinnamon" off
              2 "Gnome" off
              3 "KDE" off
              4 "LXDE" off
              5 "Mate" on
              6 "XFCE" off)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            echo ""
            echo -e "${ColorVerde}Instalando escritorio Cinnamon...${FinColor}"
            echo ""
            tasksel install cinnamon-dektop
            apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es
          ;;

          2)
            echo ""
            echo -e "${ColorVerde}Instalando escritorio Gnome...${FinColor}"
            echo ""
            tasksel install gnome-dektop
            apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es
          ;;

          3)
            echo ""
            echo -e "${ColorVerde}Instalando escritorio KDE...${FinColor}"
            echo ""
            tasksel install kde-dektop
            apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es
          ;;

          4)
            echo ""
            echo -e "${ColorVerde}Instalando escritorio LXDE...${FinColor}"
            echo ""
            tasksel install lxde-dektop
            apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es
          ;;

          5)
            echo ""
            echo -e "${ColorVerde}Instalando escritorio Mate...${FinColor}"
            echo ""
            tasksel install mate-dektop
            /root/nipe-scripts/debian10/ÚnicaEjecución/Escritorio/PostInstalaciónDeEscritorioMate 
            systemctl disable NetworkManager.service
          ;;

          6)
            echo ""
            echo -e "${ColorVerde}Instalando escritorio XFCE...${FinColor}"
            echo ""
            tasksel install xfce-dektop
            apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es
          ;;

        esac

done

echo ""
echo -e "${ColorVerde}Ejecución del script, finalizada.${FinColor}"
echo ""

