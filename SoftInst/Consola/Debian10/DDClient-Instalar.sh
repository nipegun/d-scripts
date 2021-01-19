#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar DirectUpdate en Debian10
#------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo ""
echo -e "${ColorVerde}-------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación de DDClient...${FinColor}"
echo -e "${ColorVerde}-------------------------------------------------${FinColor}"
echo ""
echo ""

ColorVerde="\033[1;32m"
FinColor="\033[0m"

apt-get -y update 2> /dev/null
apt-get -y install dialog 2> /dev/null

menu=(dialog --timeout 5 --checklist "Opciones:" 22 76 16)
  opciones=(1 "Instalar para actualizar noip.com" off
            2 "Instalar para actualizar strato" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

        ;;

        2)
          touch /etc/default/ddclient
          echo 'run_dhclient="true"'  >> /etc/default/ddclient
          echo 'run_ipup="true"'      >> /etc/default/ddclient
          echo 'run_daemon="true"'    >> /etc/default/ddclient
          echo 'daemon_interval="60"' >> /etc/default/ddclient

          touch /etc/ddclient.conf
          echo "protocol=dyndns2"                     >> /etc/ddclient.conf
          echo "use=web, web=checkip.dyndns.org"      >> /etc/ddclient.conf
          echo "ssl=yes"                              >> /etc/ddclient.conf
          echo "server=dyndns.strato.com/nic/update"  >> /etc/ddclient.conf
          echo "login=x"                              >> /etc/ddclient.conf
          echo "password='x'"                         >> /etc/ddclient.conf
          echo "web.com"                              >> /etc/ddclient.conf
          
          apt-get -y install ddclient
        ;;

      esac

done

