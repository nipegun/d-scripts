#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar nueva llave para firmar repositorios en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/APTKey-BajarEInstalar.sh | bash
# ----------

vURLKey="$1"
vNombreServicio="$2"

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 13 (Trixie)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 12 (Bookworm)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 11 (Bullseye)..." 
  echo ""

  sudo mkdir -p /root/aptkeys/ 2> /dev/null
  sudo wget -q -O- $vURLKey -O /root/aptkeys/$vNombreServicio.key
  sudo gpg --dearmor /root/aptkeys/$vNombreServicio.key
  sudo cp -f /root/aptkeys/$vNombreServicio.key.gpg /usr/share/keyrings/$vNombreServicio.key.gpg

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 10 (Buster)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 9 (Stretch)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 8 (Jessie)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de nueva llave apt para Debian 7 (Wheezy)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

