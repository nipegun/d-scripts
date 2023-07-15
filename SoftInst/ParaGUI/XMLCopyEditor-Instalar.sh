#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar XMLCopyEditor en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/XMLCopyEditor-Instalar.sh | bash
# ----------

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
  echo "---------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de XMLCopyEditor para Debian 7 (Wheezy)..."
  echo "---------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de jDownloader para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de XMLCopyEditor para Debian 9 (Stretch)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de XMLCopyEditor para Debian 10 (Buster)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""

  echo "  Iniciando el script de instalación de XMLCopyEditor para Debian 11 (Bullseye)..."

  echo ""

  # Desde repositorio
    apt-get -y update && apt-get -y install xmlcopyeditor

  # Instalar dependencias
    apt-get -y install libenchant1c2a
    apt-get -y install libexpat1
    apt-get -y install libgtk-3-0
    apt-get -y install libwxbase3.0-0v5
    apt-get -y install libwxgtk3.0-gtk3-0v5
    apt-get -y install libxerces-c3.2
    apt-get -y install libxslt1.1

  # Descargar paquete
    URLArchivo=$(curl -s https://xml-copy-editor.sourceforge.io/ | grep .deb | grep href | cut -d'"' -f2 | head -n1)
    mkdir-p /root/SoftInst/XMLCopyEditor/ 2> /dev/null
    curl -s -L $URLArchivo --output /root/SoftInst/XMLCopyEditor/XMLCopyEditor.deb
    dpkg -i /root/SoftInst/XMLCopyEditor/XMLCopyEditor.deb

fi

