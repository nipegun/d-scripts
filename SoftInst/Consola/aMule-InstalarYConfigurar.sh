#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar aMule en Debian
#--------------------------------------------------------------------

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi


if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de amule para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de amule para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 8 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de amule para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalando el paquete amule-daemon..."
  echo ""
  apt-get -y install amule-daemon

  echo ""
  echo "Agregando el usuario debian-amule..."
  echo ""
  adduser debian-amule

  echo ""
  echo "Corriendo el comando amuled por primera vez para el usuario debian-amule..."
  echo ""
  runuser -l debian-amule -c 'amuled'

  echo ""
  echo "Deteniendo el servicio amule-daemon..."
  echo ""
  service amule-daemon stop

  echo ""
  echo "Realizando cambios en la configuración..."
  echo ""

  runuser -l debian-amule -c 'amuleweb --write-config --host=localhost --password=password --admin-pass=adminpassword'
  AdminPassword=$(echo -n adminpassword | md5sum | cut -d ' ' -f 1)
  sed -i -e 's|AcceptExternalConnections=0|AcceptExternalConnections=1|g' /home/debian-emule/.aMule/amule.conf
  sed -i -e 's|ECPassword=|ECPassword=$AdminPassword|g' /home/debian-amule/.aMule/amule.conf
  sed -i '/WebServer]/{n;s/.*/Enabled=1/}' /home/debian-amule/.aMule/amule.conf
  sed -i -e 's|^Password=|Password=5f4dcc3b5aa765d61d8327deb882cf99|g' /home/debian-amule/.aMule/amule.conf
  sed -i -e 's|AMULED_USER=""|AMULED_USER="debian-amule"|g' /etc/default/amule-daemon

  echo ""
  echo "Iniciando el servicio amule-daemon..."
  echo ""
  service amule-daemon start

  #echo ""
  #echo "Agregando el usuario al grupo amule-daemon..."
  #echo ""
  #usermod -a -G debian-amule debian-amule

  #bajar el IPFilter desde aqui:
  #https://89f8c187-a-62cb3a1a-s-sites.googlegroups.com/site/ircemulespanish/descargas-2/ipfilter.zip

  echo ""
  echo "--------------------------------------------------------------"
  echo "  El demonio amule ha sido instalado, configurado e inciado."
  echo ""
  echo "  Deberías poder administrarlo mediante web en la IP de"
  echo "  este ordenador seguida por :4711"
  echo ""
  echo "  Ejemplo: 192.168.0.120:4711"
  echo ""
  echo "  Nombre de usuario: debian-amule"
  echo "  Contraseña: password"
  echo "---------------------------------------------------------"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de amule para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 10 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de amule para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 11 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

fi

