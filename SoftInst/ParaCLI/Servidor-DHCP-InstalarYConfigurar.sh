#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar el servidor DHCP en Debian
#
#  Ejecución remota:
#  curl -s x | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' x | bash
#
#  Ejecución remota con parámetros:
#  curl -s x | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del servidor DHCP para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del servidor DHCP para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del servidor DHCP para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del servidor DHCP para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación del servidor DHCP para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Instalando el servidor DHCP:" 22 96 16)
    opciones=(
      1 "Instalar y configurar para redes de clase A" of
      2 "Instalar y configurar para redes de clase B" off
      3 "Instalar y configurar para redes de clase C" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando y configurando DHCP para redes de clase A..."
            echo ""

            # Instalar el paquete isc-dhcp-server
              echo ""
              echo "    Instalando el paquete isc-dhcp-server..."
              echo ""
              apt-get -y update && apt-get -y install isc-dhcp-server

            # Indicar la ubicación del archivo de configuración del demonio
              echo ""
              echo "    Indicando la ubicación del archivo de configuración del demonio dhcpd"
              echo "    y la interfaz sobre la que correrá..."
              echo ""
              cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
              echo 'DHCPDv4_CONF=/etc/dhcp/dhcpd.conf'  > /etc/default/isc-dhcp-server
              echo 'INTERFACESv4="eth0"'               >> /etc/default/isc-dhcp-server
              echo 'INTERFACESv6=""'                   >> /etc/default/isc-dhcp-server

            # Configurar servidor DHCP
              echo ""
              echo "    Configurando el servidor DHCP..."
              echo ""
              cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.ori
              echo "authoritative;"                                  > /etc/dhcp/dhcpd.conf
              echo "subnet 10.0.0.0 netmask 255.0.0.0 {"            >> /etc/dhcp/dhcpd.conf
              echo "  range 10.0.0.2 10.255.255.254;"               >> /etc/dhcp/dhcpd.conf
              echo "  option routers 10.0.0.1;"                     >> /etc/dhcp/dhcpd.conf
              echo "  option domain-name-servers 1.1.1.1, 1.0.0.1;" >> /etc/dhcp/dhcpd.conf
              echo "  default-lease-time 600;"                      >> /etc/dhcp/dhcpd.conf
              echo "  max-lease-time 7200;"                         >> /etc/dhcp/dhcpd.conf
              echo ""                                               >> /etc/dhcp/dhcpd.conf
              echo "  host PrimeraReserva {"                        >> /etc/dhcp/dhcpd.conf
              echo "    hardware ethernet 00:00:00:00:00:01;"       >> /etc/dhcp/dhcpd.conf
              echo "    fixed-address 10.0.0.10;"                   >> /etc/dhcp/dhcpd.conf
              echo "  }"                                            >> /etc/dhcp/dhcpd.conf
              echo "}"                                              >> /etc/dhcp/dhcpd.conf

            # Descargar archivo de nombres de fabricantes
              echo ""
              echo "    Descargando archivo de nombres de fabricantes..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                   echo ""
                   echo -e "${vColorRojo}      wget no está instalado. Iniciando su instalación...${vFinColor}"
                   echo ""
                   apt-get -y update && apt-get -y install wget
                   echo ""
                 fi
              wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt

          ;;

          2)

            echo ""
            echo "  Instalando y configurando el servidor DHCP para redes de clase B..."
            echo ""

            # Instalar el paquete isc-dhcp-server
              echo ""
              echo "    Instalando el paquete isc-dhcp-server..."
              echo ""
              apt-get -y update && apt-get -y install isc-dhcp-server

            # Indicar la ubicación del archivo de configuración del demonio
              echo ""
              echo "    Indicando la ubicación del archivo de configuración del demonio dhcpd"
              echo "    y la interfaz sobre la que correrá..."
              echo ""
              cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
              echo 'DHCPDv4_CONF=/etc/dhcp/dhcpd.conf'  > /etc/default/isc-dhcp-server
              echo 'INTERFACESv4="eth0"'               >> /etc/default/isc-dhcp-server
              echo 'INTERFACESv6=""'                   >> /etc/default/isc-dhcp-server

            # Configurar servidor DHCP
              echo ""
              echo "    Configurando el servidor DHCP..."
              echo ""
              cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.ori
              echo "authoritative;"                                  > /etc/dhcp/dhcpd.conf
              echo "subnet 172.16.0.0 netmask 255.255.0.0 {"        >> /etc/dhcp/dhcpd.conf
              echo "  range 172.16.0.2 172.16.255.254;"             >> /etc/dhcp/dhcpd.conf
              echo "  option routers 172.16.0.1;"                   >> /etc/dhcp/dhcpd.conf
              echo "  option domain-name-servers 1.1.1.1, 1.0.0.1;" >> /etc/dhcp/dhcpd.conf
              echo "  default-lease-time 600;"                      >> /etc/dhcp/dhcpd.conf
              echo "  max-lease-time 7200;"                         >> /etc/dhcp/dhcpd.conf
              echo ""                                               >> /etc/dhcp/dhcpd.conf
              echo "  host PrimeraReserva {"                        >> /etc/dhcp/dhcpd.conf
              echo "    hardware ethernet 00:00:00:00:00:01;"       >> /etc/dhcp/dhcpd.conf
              echo "    fixed-address 172.16.0.10;"                 >> /etc/dhcp/dhcpd.conf
              echo "  }"                                            >> /etc/dhcp/dhcpd.conf
              echo "}"                                              >> /etc/dhcp/dhcpd.conf

            # Descargar archivo de nombres de fabricantes
              echo ""
              echo "    Descargando archivo de nombres de fabricantes..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                   echo ""
                   echo -e "${vColorRojo}      wget no está instalado. Iniciando su instalación...${vFinColor}"
                   echo ""
                   apt-get -y update && apt-get -y install wget
                   echo ""
                 fi
              wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt

          ;;

          3)

            echo ""
            echo "  Instalando y configurando el servidor DHCP para redes de clase C..."
            echo ""

            # Instalar el paquete isc-dhcp-server
              echo ""
              echo "    Instalando el paquete isc-dhcp-server..."
              echo ""
              apt-get -y update && apt-get -y install isc-dhcp-server

            # Indicar la ubicación del archivo de configuración del demonio
              echo ""
              echo "    Indicando la ubicación del archivo de configuración del demonio dhcpd"
              echo "    y la interfaz sobre la que correrá..."
              echo ""
              cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
              echo 'DHCPDv4_CONF=/etc/dhcp/dhcpd.conf'  > /etc/default/isc-dhcp-server
              echo 'INTERFACESv4="eth0"'               >> /etc/default/isc-dhcp-server
              echo 'INTERFACESv6=""'                   >> /etc/default/isc-dhcp-server

            # Configurar servidor DHCP
              echo ""
              echo "    Configurando el servidor DHCP..."
              echo ""
              cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.ori
              echo "authoritative;"                                  > /etc/dhcp/dhcpd.conf
              echo "subnet 192.168.0.0 netmask 255.255.255.0 {"     >> /etc/dhcp/dhcpd.conf
              echo "  range 192.168.0.2 192.168.0.254;"             >> /etc/dhcp/dhcpd.conf
              echo "  option routers 192.168.0.1;"                  >> /etc/dhcp/dhcpd.conf
              echo "  option domain-name-servers 1.1.1.1, 1.0.0.1;" >> /etc/dhcp/dhcpd.conf
              echo "  default-lease-time 600;"                      >> /etc/dhcp/dhcpd.conf
              echo "  max-lease-time 7200;"                         >> /etc/dhcp/dhcpd.conf
              echo ""                                               >> /etc/dhcp/dhcpd.conf
              echo "  host PrimeraReserva {"                        >> /etc/dhcp/dhcpd.conf
              echo "    hardware ethernet 00:00:00:00:00:01;"       >> /etc/dhcp/dhcpd.conf
              echo "    fixed-address 192.168.0.10;"                >> /etc/dhcp/dhcpd.conf
              echo "  }"                                            >> /etc/dhcp/dhcpd.conf
              echo "}"                                              >> /etc/dhcp/dhcpd.conf

            # Descargar archivo de nombres de fabricantes
              echo ""
              echo "    Descargando archivo de nombres de fabricantes..."
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                   echo ""
                   echo -e "${vColorRojo}      wget no está instalado. Iniciando su instalación...${vFinColor}"
                   echo ""
                   apt-get -y update && apt-get -y install wget
                   echo ""
                 fi
              wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt

          ;;

      esac

  done

fi
