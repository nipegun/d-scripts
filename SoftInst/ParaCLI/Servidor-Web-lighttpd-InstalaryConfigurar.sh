#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar lighthttpd en Debian
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
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de lighthttpd para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de lighthttpd para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de lighthttpd para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de lighthttpd para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de lighthttpd para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  vFecha=$(date +A%YM%mD%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar el paquete lighttpd..." on
      2 "Opción 2" off
      3 "Opción 3" off
      4 "Opción 4" off
      5 "Opción 5" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando el paquete lighttpd..."
          echo ""
          apt-get -y update && apt-get -y install lighttpd 
          systemctl enable lighttpd --now

        ;;

        2)

          echo ""
          echo "  Instalando y activando PHP..."
          echo ""
          apt-get -y install php
          apt-get -y install php-cgi
          apt-get -y install php-fpm
          # Determinar la última versión de PHP disponible en Debian
            vUltVerPHP=$(apt-cache search php | grep etapack | grep ^php | cut -d ' ' -f1 | cut -d'p' -f3)
          sed -i -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=1|g' /etc/php/$vUltVerPHP/fpm/php.ini
          sed -i -e 's|listen = /run/php/php$vUltVerPHP-fpm.sock|listen = 127.0.0.1:9000|g' /etc/php/$vUltVerPHP/fpm/pool.d/www.conf
          systemctl restart php$vUltVerPHP-fpm
          sed -i -e 's|"bin-path" => "/usr/bin/php-cgi",|"host" => "127.0.0.1",|g'                                /etc/lighttpd/conf-available/15-fastcgi-php.conf
          sed -i -e 's|"socket" => "/var/run/lighttpd/php.socket",|"socket" => "/var/run/lighttpd/php.socket",|g' /etc/lighttpd/conf-available/15-fastcgi-php.conf
          lighty-enable-mod fastcgi
          lighty-enable-mod fastcgi-php
          systemctl restart lighttpd

        ;;

        3)

          echo ""
          echo "  Instalar MariaDB..."
          echo ""
          apt-get -y install php-mysql
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${vColorRojo}    curl no está instalado. Iniciando su instalación...${vFinColor}"
            echo ""
            apt-get -y update && apt-get -y install curl
            echo ""
          fi
          curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash

        ;;

        4)

          echo ""
          echo "  Opción 4..."
          echo ""

        ;;

        5)

          echo ""
          echo "  Opción 5..."
          echo ""

        ;;


    esac

done



fi
