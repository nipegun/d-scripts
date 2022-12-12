#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar MariaDB en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  curl no está instalado. Iniciando su instalación...${vFinColor}"
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
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de MariaDB para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de MariaDB para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de MariaDB para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de MariaDB para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar paquete mariadb-server." on
      2 "Permitir conexiones desde todas las IPs (no sólo localhost)." off
      3 "Permitir conexión SÓLO desde una IP específica (sin localhost)." off
      4 "Establecer política de contraseñas débiles (sólo para pruebas)." off
      5 "..." off
      6 "Securizar instalación con script oficial." off
      7 "Crear base de datos para wordpress" off
      8 "Crear base de datos para Joomla" off
      
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando paquete mariadb-server..."
          echo ""
          apt-get -y updat
          apt-get -y install mariadb-server

        ;;

        2)

          echo ""
          echo "  Permitiendo conexión desde todas las IPs (no sólo desde localhost)..."
          echo ""
          echo ""                       >> /etc/mysql/my.cnf
          echo "[mysqld]"               >> /etc/mysql/my.cnf
          echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf
          systemctl restart mariadb

        ;;

        3)

          echo ""
          echo "  Permitiendo conexión SÓLO desde una IP específica (sin localhost)..."
          echo ""
          echo "    Introduce la IP desde la que se deberían escuchar las conexiones y presiona Enter:"
          echo ""
          read vIPExtra < /dev/tty
          echo ""
          echo ""                         >> /etc/mysql/my.cnf
          echo "[mysqld]"                 >> /etc/mysql/my.cnf
          echo "bind-address = $vIPExtra" >> /etc/mysql/my.cnf
          systemctl restart mariadb

        ;;

        4)

          echo ""
          echo "  Estableciendo política de contraseñas débiles (sólo para pruebas)..."
          echo ""
          vExisteSec=$(cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
          if [[ $vExisteSec == "" ]]; then
            echo "[mysqld]"                     >> /etc/mysql/my.cnf
            echo "validate_password.policy=LOW" >> /etc/mysql/my.cnf
          else
            sed -i -e 's|\[mysqld]|\[mysqld]\nvalidate_password.policy=LOW|g' /etc/mysql/my.cnf
          fi

        ;;

        5)

          echo "  ..."

        ;;

        6)

          echo ""
          echo "  Securizando instalación con script oficial..."
          echo ""
          mysql_secure_installation

        ;;

        7)

          echo ""
          echo "  Creando base de datos para WordPress..."
          echo ""
          
        ;;

        8)

          echo ""
          echo "  Creando base de datos para Joomla..."
          echo ""

        ;;

      esac

  done

fi

