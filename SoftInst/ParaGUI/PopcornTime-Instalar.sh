#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar PopcornTime en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/PopcornTime-Instalar.sh | bash
# ----------

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
  echo "  Iniciando el script de instalación de PopcornTime para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de PopcornTime para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de PopcornTime para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de PopcornTime para Debian 10 (Buster)..."
  
  echo ""

  apt-get update
  apt-get -y install wget
  ArchivoADescargar=$(wget --no-check-certificate -qO- https://get.popcorntime.sh/repo/build/ | grep Linux-64 | head -n 1 | cut -d\" -f2)
  mkdir /root/paquetes/
  cd /root/paquetes/
  wget --no-check-certificate https://get.popcorntime.sh/repo/build/$ArchivoADescargar
  mkdir /opt/popcorn-time
  tar -xvf $ArchivoADescargar -C /opt/popcorn-time
  ln -sf /opt/popcorn-time/Popcorn-Time /usr/bin/popcorn-time
  echo "[Desktop Entry]"                           > /usr/share/applications/popcorntime.desktop
  echo "Version = 1.0"                            >> /usr/share/applications/popcorntime.desktop
  echo "Type = Application"                       >> /usr/share/applications/popcorntime.desktop
  echo "Terminal = false"                         >> /usr/share/applications/popcorntime.desktop
  echo "Name = Popcorn Time"                      >> /usr/share/applications/popcorntime.desktop
  echo "Exec = /usr/bin/popcorn-time"             >> /usr/share/applications/popcorntime.desktop
  echo "Icon = /opt/popcorn-time/popcorntime.png" >> /usr/share/applications/popcorntime.desktop
  echo "Categories = Application;"                >> /usr/share/applications/popcorntime.desktop
  wget -q -O /opt/popcorn-time/popcorntime.png https://upload.wikimedia.org/wikipedia/commons/6/6c/Popcorn_Time_logo.png

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de PopcornTime para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
