#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar python2 en Debian
#
# Ejecución remota (puede requierir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python2-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python2-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python2-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 13 (x)...${cFinColor}"
    echo ""

    # Instalar paquetes necesarios para compilar
      sudo apt-get -y update
      sudo apt-get -y install build-essential
      sudo apt-get -y install zlib1g-dev
      sudo apt-get -y install libssl-dev
      sudo apt-get -y install libncurses5-dev
      sudo apt-get -y install libffi-dev
      sudo apt-get -y install libsqlite3-dev
      sudo apt-get -y install libncursesw5-dev
      sudo apt-get -y install libreadline-dev
      sudo apt-get -y install libsqlite3-dev
      sudo apt-get -y install libgdbm-dev
      sudo apt-get -y install libdb5.3-dev
      sudo apt-get -y install libbz2-dev
      sudo apt-get -y install libexpat1-dev
      sudo apt-get -y install liblzma-dev
      sudo apt-get -y install zlib1g-dev
      sudo apt-get -y install tk-dev
      sudo apt-get -y install tcl-dev
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
            sudo apt-get -y update
            sudo apt-get -y install curl
            echo ""
          fi
        vUltVersPython2=$(curl -sL https://www.python.org/ftp/python/ | grep href | cut -d'"' -f2 | cut -d'/' -f1 | grep ^[0-9] | sort -n | grep ^2 | tail -n1)
        echo ""
        echo "      La última versión es la $vUltVersPython2"
        echo ""
    # Descargando la última versión
      sudo rm -rf /tmp/SoftInst/Python-$vUltVersPython2/
      sudo mkdir -p /tmp/SoftInst/
      sudo rm -f /tmp/python2.tgz
      curl -L https://www.python.org/ftp/python/$vUltVersPython2/Python-$vUltVersPython2.tgz -o /tmp/python2.tgz
      sudo tar -xzf /tmp/python2.tgz -C /tmp/SoftInst/
      cd /tmp/SoftInst/Python-$vUltVersPython2/
      # sudo ./configure --prefix=/usr/local --with-ssl=/path/to/openssl
      # sudo ./configure --prefix=/opt/python2 --with-ensurepip=install --enable-optimizations   # Instala también /opt/python2/bin/pip2.7
      sudo ./configure --prefix=/opt/python2 --enable-optimizations
      sudo make -j $(nproc)
      sudo make altinstall       # No se usa install para no sobreescribir la instalación de Python3
      # Instalar pip2
        vVersBinario=$(ls /opt/python2/bin/ | grep python | grep -v config | sed 's-python--g')
        curl -L https://bootstrap.pypa.io/pip/$vVersBinario/get-pip.py -o /tmp/get-pip.py
        sudo /opt/python2/bin/python$vVersBinario /tmp/get-pip.py
      # Instalar virtualenv
        sudo /opt/python2/bin/pip2 install virtualenv

    # Notificar fin de ejecución del script
      echo ""
      echo "    Python $vUltVersPython2 se ha instalado en /opt/python2/"
      echo ""
      echo "      El binario está en /opt/python2/bin/python$vVersBinario"
      echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar paquetes necesarios para compilar
      sudo apt-get -y update
      sudo apt-get -y install build-essential
      sudo apt-get -y install zlib1g-dev
      sudo apt-get -y install libssl-dev
      sudo apt-get -y install libncurses5-dev
      sudo apt-get -y install libffi-dev
      sudo apt-get -y install libsqlite3-dev
      sudo apt-get -y install libncursesw5-dev
      sudo apt-get -y install libreadline-dev
      sudo apt-get -y install libsqlite3-dev
      sudo apt-get -y install libgdbm-dev
      sudo apt-get -y install libdb5.3-dev
      sudo apt-get -y install libbz2-dev
      sudo apt-get -y install libexpat1-dev
      sudo apt-get -y install liblzma-dev
      sudo apt-get -y install zlib1g-dev
      sudo apt-get -y install tk-dev
      sudo apt-get -y install tcl-dev
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
            sudo apt-get -y update
            sudo apt-get -y install curl
            echo ""
          fi
        vUltVersPython2=$(curl -sL https://www.python.org/ftp/python/ | grep href | cut -d'"' -f2 | cut -d'/' -f1 | grep ^[0-9] | sort -n | grep ^2 | tail -n1)
        echo ""
        echo "      La última versión es la $vUltVersPython2"
        echo ""
    # Descargando la última versión
      sudo rm -rf /tmp/SoftInst/Python-$vUltVersPython2/
      sudo mkdir -p /tmp/SoftInst/
      sudo rm -f /tmp/python2.tgz
      curl -L https://www.python.org/ftp/python/$vUltVersPython2/Python-$vUltVersPython2.tgz -o /tmp/python2.tgz
      sudo tar -xzf /tmp/python2.tgz -C /tmp/SoftInst/
      cd /tmp/SoftInst/Python-$vUltVersPython2/
      # sudo ./configure --prefix=/usr/local --with-ssl=/path/to/openssl
      # sudo ./configure --prefix=/opt/python2 --with-ensurepip=install --enable-optimizations   # Instala también /opt/python2/bin/pip2.7
      sudo ./configure --prefix=/opt/python2 --enable-optimizations
      sudo make -j $(nproc)
      sudo make altinstall       # No se usa install para no sobreescribir la instalación de Python3
      # Instalar pip2
        vVersBinario=$(ls /opt/python2/bin/ | grep python | grep -v config | sed 's-python--g')
        curl -L https://bootstrap.pypa.io/pip/$vVersBinario/get-pip.py -o /tmp/get-pip.py
        sudo /opt/python2/bin/python$vVersBinario /tmp/get-pip.py
      # Instalar virtualenv
        sudo /opt/python2/bin/pip2 install virtualenv

    # Notificar fin de ejecución del script
      echo ""
      echo "    Python $vUltVersPython2 se ha instalado en /opt/python2/"
      echo ""
      echo "      El binario está en /opt/python2/bin/python$vVersBinario"
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de python2 para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
