#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para routear todo el tráfico de debian mediante TOR
#
# Ejecución remota:
# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/TOR-RoutearTodo.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 7 (Wheezy) mediante TOR..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 8 (Jessie) mediante TOR..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 9 (Stretch) mediante TOR..."
  echo "------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 10 (Buster) mediante TOR..."
  echo "------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 11 (Bullseye) mediante TOR..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  # Determinar IP Pública del equipo
     # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  curl no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install curl
          echo ""
        fi
     IPWAN=$(curl --silent ipinfo.io/ip)
     echo ""
     echo -e "${cColorVerde}  La IP pública de este equipo es: $IPWAN ${cFinColor}"
     echo ""

  # Mostrar el estado de los puertos actuales del sistema
     echo ""
     echo -e "${cColorVerde}  Ahora mismo el sistema tiene en funcionamiento los siguientes puertos:${cFinColor}"
     echo ""
     nmap 127.0.0.1 -p 1-65535
     echo ""

  # Purgar TOR
     echo ""
     echo -e "${cColorVerde}  Eliminando toda la instalación de TOR...${cFinColor}"
     echo ""
     systemctl stop tor.service
     rm -f /etc/tor/tor.rc 2> /dev/null
     apt-get -y purge tor tor-geoipdb torsocks > /dev/null
     apt-get -y autoremove > /dev/null

  # Comprobar si el paquete tor está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s tor 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  tor no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install tor
       echo ""
     fi

  # Mostrar el estado de los puertos actuales del sistema
     echo ""
     echo -e "${cColorVerde}  Después de instalar TOR el sistema tiene en funcionamiento los siguientes puertos:${cFinColor}"
     echo ""
     nmap 127.0.0.1 -p 1-65535
     echo ""

  # Parar el servicio tor
     systemctl stop tor.service

  # Modificar archivo de configuraciónm
     echo "AutomapHostsOnResolve 1"  > /etc/tor/torrc
     echo "TransPort 9040"          >> /etc/tor/torrc
     echo "DNSPort 4053"            >> /etc/tor/torrc

  # Crear reglas de IP Tables para todo el tráfico
     # Comprobar si el paquete iptables está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s iptables 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  iptables no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install iptables
          echo ""
        fi
     echo ""
     echo -e "${cColorVerde}  Estableciendo reglas del cortafuegos con IPTables...${cFinColor}"
     echo ""
     echo '#!/bin/bash'                                                                     > /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo ""                                                                               >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo "iptables -t nat -A OUTPUT -p tcp -m tcp -j REDIRECT --to-ports 9040"            >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo "iptables -t nat -A OUTPUT -p udp -m udp --dport 53 -j REDIRECT --to-ports 4053" >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo ""                                                                               >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo 'echo ""'                                                                        >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo 'echo "  La tabla nat ahora ha quedado de la siguiente manera:"'                 >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo 'echo ""'                                                                        >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo "iptables -t nat -L -n -v"                                                       >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     echo 'echo ""'                                                                        >> /root/scripts/ReglasIPTablesRoutearPorTOR.sh
     chmod +x                                                                                 /root/scripts/ReglasIPTablesRoutearPorTOR.sh

  # Crear reglas de IP tables para un usuario sólo
     #iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner usuariox -m tcp -j REDIRECT --to-ports 9040
     #iptables -t nat -A OUTPUT -p udp -m owner --uid-owner usuariox -m udp --dport 53 -j REDIRECT --to-ports 4053

  # Re-leer los archivos de configuración de los daemons
     systemctl daemon-reload
     systemctl restart tor.service

  # Volver a determinar la IP pública del equipo
     IPWAN=$(curl --silent ipinfo.io/ip)
     echo ""
     echo -e "${cColorVerde}  La IP pública de este equipo ahora es: $IPWAN ${cFinColor}"
     echo ""

fi
