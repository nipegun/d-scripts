#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------
#  Script de NiPeGun para poner todos los repos en Debian
#----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

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
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar todos los repos de Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar todos los repos de Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  cp /etc/apt/sources.list /etc/apt/sources.list.bak

  echo "deb http://ftp.debian.org/debian/ jessie main contrib non-free"              > /etc/apt/sources.list
  echo "deb-src http://ftp.debian.org/debian/ jessie main contrib non-free"         >> /etc/apt/sources.list
  echo ""                                                                           >> /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free"     >> /etc/apt/sources.list
  echo "deb-src http://ftp.debian.org/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list
  echo ""                                                                           >> /etc/apt/sources.list
  echo "deb http://security.debian.org/ jessie/updates main contrib non-free"       >> /etc/apt/sources.list
  echo "deb-src http://security.debian.org/ jessie/updates main contrib non-free"   >> /etc/apt/sources.list
  echo ""                                                                           >> /etc/apt/sources.list
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar todos los repos de Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  cp /etc/apt/sources.list /etc/apt/sources.list.bak

  echo "deb http://ftp.debian.org/debian/ stretch main contrib non-free"              > /etc/apt/sources.list
  echo "deb-src http://ftp.debian.org/debian/ stretch main contrib non-free"         >> /etc/apt/sources.list
  echo ""                                                                            >> /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free"     >> /etc/apt/sources.list
  echo "deb-src http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
  echo ""                                                                            >> /etc/apt/sources.list
  echo "deb http://security.debian.org/ stretch/updates main contrib non-free"       >> /etc/apt/sources.list
  echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free"   >> /etc/apt/sources.list
  echo ""                                                                            >> /etc/apt/sources.list
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar todos los repos de Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  cp /etc/apt/sources.list /etc/apt/sources.list.bak

  echo "deb http://deb.debian.org/debian/ buster main contrib non-free"              > /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian/ buster main contrib non-free"         >> /etc/apt/sources.list
  echo ""                                                                           >> /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian/ buster-updates main contrib non-free"     >> /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list
  echo ""                                                                           >> /etc/apt/sources.list
  echo "deb http://security.debian.org/ buster/updates main contrib non-free"       >> /etc/apt/sources.list
  echo "deb-src http://security.debian.org/ buster/updates main contrib non-free"   >> /etc/apt/sources.list
  echo ""                                                                           >> /etc/apt/sources.list
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar todos los repos de Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  cp /etc/apt/sources.list /etc/apt/sources.list.bak

  echo "deb http://deb.debian.org/debian bullseye main contrib non-free"                         > /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free"                    >> /etc/apt/sources.list
  echo ""                                                                                       >> /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free"     >> /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
  echo ""                                                                                       >> /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free"                >> /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free"            >> /etc/apt/sources.list
  echo ""                                                                                       >> /etc/apt/sources.list
  echo ""
  
fi

