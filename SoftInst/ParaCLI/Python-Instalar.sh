#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar python en Debian
#
# Ejecución remota con sudo:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Instalar.sh | sudo bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Instalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Definir fecha de ejecución del script
      cFechaDeEjec=$(date +a%Ym%md%d@%T)

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          apt-get -y update && apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Instalar la versión de Python del repo de Debian 12"             off
          2 "Bajar, compilar e instalar Python 2.7"                           off
          3 "Bajar, compilar y preparar un .deb de Python 2.7 para Debian 12" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando la versión de python del repo de Debian 12..."
              echo ""

              apt-get -y update && apt-get -y install python3

            ;;

            2)

              echo ""
              echo "  Bajando, compilando e instalando Python 2.7..."
              echo ""

              # Instalar paquetes necesarios para compilar
                apt-get -y update
                apt-get -y install build-essential
                apt-get -y install zlib1g-dev
                apt-get -y install libssl-dev
                apt-get -y install libncurses5-dev
                apt-get -y install libffi-dev
                apt-get -y install libsqlite3-dev
                apt-get -y install libncursesw5-dev
                apt-get -y install libreadline-dev
                apt-get -y install libsqlite3-dev
                apt-get -y install libgdbm-dev
                apt-get -y install libdb5.3-dev
                apt-get -y install libbz2-dev
                apt-get -y install libexpat1-dev
                apt-get -y install liblzma-dev
                apt-get -y install zlib1g-dev
                apt-get -y install tk-dev
                apt-get -y install tcl-dev
              # Descargar el código fuente
                # Determinar la última versión
                  echo ""
                  echo "    Determinando la última versión de Python 2..."
                  echo ""
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    apt-get -y update && apt-get -y install curl
                    echo ""
                  fi
                  vUltVersPython2=$(curl -sL https://www.python.org/ftp/python/ | grep href | cut -d'"' -f2 | cut -d'/' -f1 | grep ^[0-9] | sort -n | grep ^2 | tail -n1)
                  echo "\n      La última versión es la $vUltVersPython2 \n"
                # Descargando la última versión
                  rm -rf ~/SoftInst/Python2
                  mkdir -p ~/SoftInst/
                  curl -L https://www.python.org/ftp/python/$vUltVersPython2/Python-$vUltVersPython2.tgz -o /tmp/python2.tgz
                  tar -xzf /tmp/python2.tgz -C ~/SoftInst/
                  mv ~/SoftInst/Python-$vUltVersPython2 ~/SoftInst/Python2
                  cd ~/SoftInst/Python2
                  ./configure --prefix=/usr/local --enable-optimizations
                   # Es un error frecuente en compilaciones de Python 2 debido a problemas de compatibilidad con bibliotecas SSL modernas
                   #Asegurarte de tener las dependencias correctas: Python 2 puede fallar al trabajar con versiones modernas de OpenSSL. Verifica la versión instalada:
                   #  openssl version
                   #  Si usas una versión moderna, intenta instalar una versión más antigua (por ejemplo, 1.0.2 o 1.1.1). Esto puede requerir compilación manual o instalación desde fuentes externas.
                   #./configure --prefix=/usr/local/python2 --with-ssl=/path/to/openssl
                  make -j $(nproc)
                  make altinstall
                # Notificar fin de ejecución del script
                  echo ""
                  echo "    Python 2.7 se ha instalado en:"
                  echo "      /usr/local/bin/python2.7"
                  echo ""

            ;;

            3)

              echo ""
              echo "  Bajar, compilar y preparar un .deb de Python 2.7 para Debian12..."
              echo ""

              # Instalar paquetes necesarios para compilar
                apt-get -y update
                apt-get -y install build-essential
                apt-get -y install zlib1g-dev
                apt-get -y install libssl-dev
                apt-get -y install libncurses5-dev
                apt-get -y install libffi-dev
                apt-get -y install libsqlite3-dev
                apt-get -y install libncursesw5-dev
                apt-get -y install libreadline-dev
                apt-get -y install libsqlite3-dev
                apt-get -y install libgdbm-dev
                apt-get -y install libdb5.3-dev
                apt-get -y install libbz2-dev
                apt-get -y install libexpat1-dev
                apt-get -y install liblzma-dev
                apt-get -y install zlib1g-dev
                apt-get -y install checkinstall

              # Descargar el código fuente
                # Determinar la última versión
                  echo ""
                  echo "    Determinando la última versión de Python 2..."
                  echo ""
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    apt-get -y update && apt-get -y install curl
                    echo ""
                  fi
                  vUltVersPython2=$(curl -sL https://www.python.org/ftp/python/ | grep href | cut -d'"' -f2 | cut -d'/' -f1 | grep ^[0-9] | sort -n | grep ^2 | tail -n1)
                  echo "      La última versión es la $vUltVersPython2"
                # Descargando la última versión
                  rm -rf ~/SoftInst/Python2
                  mkdir -p ~/SoftInst/
                  curl -L https://www.python.org/ftp/python/$vUltVersPython2/Python-$vUltVersPython2.tgz -o /tmp/python2.tgz
                  tar -xzf /tmp/python2.tgz -C ~/SoftInst/
                  mv ~/SoftInst/Python-$vUltVersPython2 ~/SoftInst/Python2
                  cd ~/SoftInst/Python2
                  ./configure --prefix=/usr/local --enable-optimizations
                  make -j $(nproc)
                  checkinstall

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
