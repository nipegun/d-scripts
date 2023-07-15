#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar TORGhost en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/TorGhost-Instalar.sh | bash
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
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TORGhost para Debian 7 (Wheezy)..."  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TORGhost para Debian 8 (Jessie)..."  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TORGhost para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de TORGhost para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TORGhost para Debian 11 (Bullseye)..."  echo "-------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  git no está instalado. Iniciando su instalación..."     echo ""
     apt-get -y update
     apt-get -y install git
     echo ""
   fi
  cd /
  rm -rf /root/SoftInst/TorGhost/ 2> /dev/null
  mkdir -p /root/SoftInst/TorGhost/
  cd /root/SoftInst/TorGhost/
  git clone https://github.com/SusmithKrishnan/torghost.git
  mv torghost GitHub
  cd GitHub
  chmod +x build.sh
  apt-get -y install cython3
  UltVersDevel=$(apt-cache search python3. | grep 3.9 | grep eader | cut -d ' ' -f1 | grep -v lib)
  apt-get -y install $UltVersDevel
  VersDevInst=$(echo $UltVersDevel | cut -d '-' -f1 | cut -d 'n' -f2)
  VersDevScript=$(cat /root/SoftInst/TorGhost/GitHub/build.sh | grep gcc | cut -d '/' -f4 | cut -d ' ' -f1 | cut -d 'n' -f2)
  sed -i -e "s|python$VersDevScript|python$VersDevInst|g" /root/SoftInst/TorGhost/GitHub/build.sh
  find /root/SoftInst/TorGhost/GitHub/ -type f -exec sed -i 's/sudo//g' {} +
  pip3 install packaging
  ./build.sh

fi

