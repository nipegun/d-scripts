#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar la última versión de binwalk en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Binwalk-Instalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Binwalk-Instalar.sh | bash
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
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Binwalk para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Binwalk para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Binwalk para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Binwalk para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Binwalk para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Instalar dependencias
    echo ""
    echo "    Instalando dependencias..."
    echo ""
    apt-get -y update
    apt-get -y autoremove binwalk
    apt-get -y install zlib1g-dev
    apt-get -y install liblzma-dev
    apt-get -y install liblzo2-dev
    apt-get -y install wget
    apt-get -y install tar
    apt-get -y install python
    apt-get -y install python3-pip
    apt-get -y install python3-opengl
    apt-get -y install python3-numpy
    apt-get -y install python3-scipy
    apt-get -y install mtd-utils
    apt-get -y install gzip
    apt-get -y install bzip2
    apt-get -y install tar
    apt-get -y install arj
    apt-get -y install lhasa
    apt-get -y install p7zip
    apt-get -y install p7zip-full
    apt-get -y install cabextract
    apt-get -y install cramfsprogs
    apt-get -y install cramfsswap
    apt-get -y install squashfs-tools
    apt-get -y install sleuthkit
    apt-get -y install default-jdk
    apt-get -y install lzop
    apt-get -y install srecord

    apt-get -y install libqt4-opengl          # No se instala
    apt-get -y install python3-pyqt4          # No se instala
    apt-get -y install python3-pyqt4.qtopengl # No se instala

  # Instalar dependencias python
    echo ""
    echo "    Instalando dependencias de Python..."
    echo ""
    pip3 install nose
    pip3 install coverage
    pip3 install pycryptodome
    pip3 install pyqtgraph
    pip3 install capstone

  # Instalar sasquatch
    echo ""
    echo "    Instalando sasquatch..."
    echo ""
    mkdir -p /root/SoftInst
    rm -rf /root/SoftInst/sasquatch/
    cd /root/SoftInst
    git clone --quiet --depth 1 --branch "master" https://github.com/devttys0/sasquatch
    cd /root/SoftInst/sasquatch
    wget https://raw.githubusercontent.com/devttys0/sasquatch/82da12efe97a37ddcd33dba53933bc96db4d7c69/patches/patch0.txt
    mv patch0.txt /root/SoftInst/sasquatch/patches/
    ./build.sh

  # Instalar jefferson
    echo ""
    echo "    Instalando jefferson..."
    echo ""
    mkdir -p /root/SoftInst
    rm -rf /root/SoftInst/jefferson/
    cd /root/SoftInst
    git clone --quiet --depth 1 --branch "master" https://github.com/sviehb/jefferson
    cd /root/SoftInst/jefferson
    python3 -mpip install -r requirements.txt
    python3 setup.py install

  # Instalar ubi_reader
    echo ""
    echo "    Instalando ubi_reader..."
    echo ""
    mkdir -p /root/SoftInst
    rm -rf /root/SoftInst/ubi_reader/
    cd /root/SoftInst
    git clone --quiet --depth 1 https://github.com/onekey-sec/ubi_reader
    cd /root/SoftInst/ubi_reader/
    pip install --user ubi_reader
    cp -f /root/.local/bin/ubireader_display_blocks /bin/
    cp -f /root/.local/bin/ubireader_display_info   /bin/
    cp -f /root/.local/bin/ubireader_extract_files  /bin/
    cp -f /root/.local/bin/ubireader_extract_images /bin/
    cp -f /root/.local/bin/ubireader_list_files     /bin/
    cp -f /root/.local/bin/ubireader_utils_info     /bin/

  # Instalar yaffshiv
    echo ""
    echo "    Instalando yaffshiv..."
    echo ""
    mkdir -p /root/SoftInst
    rm -rf /root/SoftInst/yaffshiv/
    cd /root/SoftInst
    git clone --quiet --depth 1 --branch "master" https://github.com/devttys0/yaffshiv
    cd /root/SoftInst/yaffshiv
    python2 setup.py install

  # Instalar cramfs-tools
    echo ""
    echo "    Instalando cramfs-tools..."
    echo ""
    mkdir -p /root/SoftInst
    rm -rf /root/SoftInst/cramfs-tools/
    cd /root/SoftInst
    git clone --quiet --depth 1 --branch "master" https://github.com/npitre/cramfs-tools
    cd /root/SoftInst/cramfs-tools/
    make
    install mkcramfs "/usr/local/bin"
    install cramfsck "/usr/local/bin"

  # Instalar binwalk
    echo ""
    echo "    Instalando binwalk desde Github..."
    echo ""
    mkdir -p /root/SoftInst
    rm -rf /root/SoftInst/binwalk/
    cd /root/SoftInst
    git clone --quiet --depth 1 --branch "master" https://github.com/ReFirmLabs/binwalk
    cd /root/SoftInst/binwalk/
    python3 setup.py install

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Binwalk para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

