#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------
#  Script de NiPeGun para routear todo el tráfico de debian mediante TOR
#
# Ejecución remota:
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/TOR-RoutearTodo.sh | bash
#---------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 7 (Wheezy) mediante TOR..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 7 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 8 (Jessie) mediante TOR..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 8 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 9 (Stretch) mediante TOR..."
  echo "------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 9 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 10 (Buster) mediante TOR..."
  echo "------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 10 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para routear todo el tráfico de Debian 11 (Bullseye) mediante TOR..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  ## Determinar IP Pública del equipo
     ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
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
     echo "  La IP pública de este equipo es: $IPWAN "
     echo ""

  ## Mostrar el estado de los puertos actuales del sistema
     echo ""
     echo "  El sistema tiene en funcionamiento los siguientes puertos:"
     echo ""
     nmap 127.0.0.1 -p 1-65535
     echo ""

  ## Comprobar si el paquete tor está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s tor 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  tor no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install tor
       echo ""
     fi

  ## Modificar archivo de configuraciónm
     echo "AutomapHostsOnResolve 1" >> /etc/tor/torrc
     echo "TransPort 9040"          >> /etc/tor/torrc
     echo "DNSPort 4053"            >> /etc/tor/torrc

  ## Crear reglas de IP Tables para todo el tráfico
     ## Comprobar si el paquete iptables está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s iptables 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  iptables no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install iptables
          echo ""
        fi
     echo ""
     echo "  Estableciendo reglas del cortafuegos con IPTables..."
     echo ""
     iptables -t nat -A OUTPUT -p tcp -m tcp -j REDIRECT --to-ports 9040
     iptables -t nat -A OUTPUT -p udp -m udp --dport 53 -j REDIRECT --to-ports 4053

  ## Crear reglas de IP tables para un usuario sólo
     #iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner usuariox -m tcp -j REDIRECT --to-ports 9040
     #iptables -t nat -A OUTPUT -p udp -m owner --uid-owner usuariox -m udp --dport 53 -j REDIRECT --to-ports 4053

  ## Mostrar estado de la tabla net
     echo ""
     echo "  La tabla nat ahora ha quedado de la siguiente manera:"
     echo ""
     iptables -t nat -L -n -v
     echo ""

  ## Re-leer los archivos de configuración de los daemons
     systemctl daemon-reload
     systemctl restart tor.service

  ## Volver a determinar la IP pública del equipo
     IPWAN=$(curl --silent ipinfo.io/ip)
     echo ""
     echo "  La IP pública de este equipo ahora es: $IPWAN "
     echo ""

fi
