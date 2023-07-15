#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

-------
# Script de NiPeGun para instalar y configurar el servidor TimeMachine en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-TimeMachine-InstalarYConfigurar.sh | bash
-------

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y install build-essential
  apt-get -y install devscripts
  apt-get -y install debhelper
  apt-get -y install cdbs
  apt-get -y install autotools-dev
  apt-get -y install dh-buildinfo
  apt-get -y install d-shlibs
  apt-get -y install dh-systemd
  apt-get -y install avahi-daemon
  apt-get -y install apt-get -y install
  apt-get -y install libdb-dev
  apt-get -y install libwrap0-dev
  apt-get -y install libpam0g-dev
  apt-get -y install libcups2-dev
  apt-get -y install libkrb5-dev
  apt-get -y install libltdl3-dev
  apt-get -y install libgcrypt11-dev
  apt-get -y install libcrack2-dev
  apt-get -y install libavahi-client-dev
  apt-get -y install libldap2-dev
  apt-get -y install libacl1-dev
  apt-get -y install libevent-dev
  apt-get -y install libc6-dev
  apt-get -y install libnss-mdns
  apt-get -y autoremove
  mkdir /root/git/
  cd /root/git/
  git clone https://github.com/adiknoth/netatalk-debian
  cd netatalk-debian
  debuild -b -uc -us
  cd ..

  ls --color=auto -1 -lh -F

  echo ""
  echo "--------------------------------------------------"
  echo "  A continuación se instalarán  los .deb creados."
  echo "--------------------------------------------------"
  echo ""
  archivo1=$(ls | grep libatalk1)
  archivo2=$(ls | grep netatalk*.deb)
  dpkg -i $archivo1
  dpkg -i $archivo2

  echo ""
  echo "------------------------------------------"
  echo "  Ahora se creará el usuario timemachine."
  echo "  Deberás proporcionarle una contraseña."
  echo "  Te será requerida dos veces."
  echo "------------------------------------------"
  echo ""
  adduser --home /TimeMachine/ timemachine

  echo ""
  echo "-----------------------------------------------------"
  echo "  Se impedirá la shell para el usuario timemachine."
  echo "-----------------------------------------------------"
  echo ""
  chsh -s /bin/false timemachine

  echo ""
  echo "-------------------------------------------------------------"
  echo "  Se creará la comparticición del disco de red TimeMachine."
  echo "-------------------------------------------------------------"
  echo ""
  mkdir -p /TimeMachine/Copias/
  chown -R timemachine:timemachine /TimeMachine/
  echo "" >> /etc/netatalk/afp.conf
  echo "[TimeMachine]"               >> /etc/netatalk/afp.conf
  echo "time machine = yes"          >> /etc/netatalk/afp.conf
  echo "path = /TimeMachine/Copias/" >> /etc/netatalk/afp.conf
  echo "vol size limit = 2000000"    >> /etc/netatalk/afp.conf
  echo "valid users = timemachine"   >> /etc/netatalk/afp.conf
  systemctl enable netatalk.service
  systemctl start netatalk.service
  systemctl enable avahi-daemon.service
  systemctl start avahi-daemon.service
  shutdown -r now

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

