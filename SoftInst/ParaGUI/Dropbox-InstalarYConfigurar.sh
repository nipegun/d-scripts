#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Dropbox en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Dropbox-InstalarYConfigurar.sh | bash
# ----------

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
  echo "  Iniciando el script de instalación de Dropbox para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Dropbox para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Dropbox para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Creando la carpeta para descargar el paquete..."
  echo ""
  mkdir -p ~/paquetes/dropbox/

  echo ""
  echo "  Descargando el paquete desde la web de Dropbox..."
  echo ""
  wget -O ~/paquetes/dropbox/dropbox.tar https://www.dropbox.com/download?plat=lnx.x86_64

  echo ""
  echo "  Descomprimiendo el paquete..."
  echo ""
  tar xzf ~/paquetes/dropbox/dropbox.tar -C ~/

  echo ""
  echo "  Descargando el script de python para controlar Dropbox desde la terminal"
  echo ""
  wget -O ~/scripts/DemonioDropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py"
  chmod +x ~/scripts/DemonioDropbox.py

  echo ""
  echo "  Configurando dropbox para que se inicie con el sistema..."
  echo ""
  echo "~/scripts/DemonioDropbox.py start" >> /root/scripts/ComandosPostArranque.sh

  echo ""
  echo "  Arrancando el daemon por primera vez..."
  echo ""
  echo "  Toma nota de la url que te pondrá abajo porque deberás ingresar a ella"
  echo "  desde un nbavegador en el que tengas iniciada la sesión de Dropbox"
  echo "  para activar el dropbox que acabas de instalar."
  echo ""
  ~/.dropbox-dist/dropboxd
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Dropbox para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Dropbox para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
