#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian a la versión inmediatamente posterior
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

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
  
  echo "  Iniciando el script para actualizar Debian 7 (Wheezy) a Debian 8 (Jessie)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------"
  echo "  Iniciando el script para actualizar Debian 8 (Jessie) a Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y upgrade
  apt-get -y dist-upgrade
  dpkg -C
  apt-mark showhold
  cp /etc/apt/sources.list /etc/apt/sources.list.deb8
  sed -i -e 's|jessie|stretch|g' /etc/apt/sources.list
  apt-get -y update
  apt-get -y upgrade
  apt-get -y dist-upgrade
  apt-get autoremove
  shutdown -r now

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script para actualizar Debian 9 (Stretch) a Debian 10 (Buster)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y upgrade
  apt-get -y dist-upgrade
  dpkg -C
  apt-mark showhold
  cp /etc/apt/sources.list /etc/apt/sources.list.deb9
  sed -i -e 's|stretch|buster|g' /etc/apt/sources.list
  apt-get -y update
  apt-get -y upgrade
  apt-get -y dist-upgrade
  apt-get autoremove
  shutdown -r now

elif [ $cVerSO == "10" ]; then

  echo ""

  echo "  Iniciando el script para actualizar Debian 10 (Buster) a Debian 11 (Bullseye)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script para actualizar Debian 11 (Bullseye) a Debian 12..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
