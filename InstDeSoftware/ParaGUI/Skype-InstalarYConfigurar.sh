#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Skype en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Skype-InstalarYConfigurar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
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


if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Skype para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Skype para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Instalando Skype..." 
echo ""
  dpkg --add-architecture i386
  apt-get -y update
  apt-get -y install gdebi wget
  mkdir /root/paquetes
  cd /root/paquetes
  PaqueteLibSSL=$(wget -qO- http://ftp.at.debian.org/debian/pool/main/o/openssl/ | grep libssl | grep deb8 | grep i386 | grep -v dbg | grep -v dev | grep -v udeb | sed -n 's/.*href="\([^"]*\).*/\1/p')
  wget http://ftp.at.debian.org/debian/pool/main/o/openssl/$PaqueteLibSSL
  gdebi /root/paquetes/$PaqueteLibSSL

  wget -O skype.deb http://www.skype.com/go/getskype-linux-deb
  gdebi skype.deb

  # apt-get purge ".*:i386"
  # dpkg --remove-architecture i386

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Skype para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Skype para Debian 10 (Buster)..."  
  echo ""

  apt-get -y update
  apt-get -y install gdebi wget
  mkdir -p /root/SoftInst/Skype
  cd /root/SoftInst/Skype
  wget https://go.skype.com/skypeforlinux-64.deb
  gdebi skypeforlinux-64.deb

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Skype para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Skype para Debian 12 (Bookworm)..."  
  echo ""

  # Descargar el apquete
    echo ""
    echo "  Descargando el paquete..."
    echo ""
    mkdir -p /root/SoftInst/Skype
    cd /root/SoftInst/Skype
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "    El paquete wget no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install wget
        echo ""
      fi
    wget https://go.skype.com/skypeforlinux-64.deb

  # Instalar el paquete
    echo ''
    echo '  Instalando el paquete ...'
    echo ''
    dpkg -i skypeforlinux-64.deb

fi

