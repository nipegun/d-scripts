#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar MLDonkey en Debian
#--------------------------------------------------------------------

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MLDonkey para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MLDonkey para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 8 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MLDonkey para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  CantArgsEsperados=1
  ArgsInsuficientes=65

  if [ $# -ne $CantArgsEsperados ]
    then
      echo ""
      echo "------------------------------------------------------------------------------"
      echo -e "${ColorAdvertencia}Mal uso del script.${FinColor} El uso correcto sería:"
      echo ""
      echo -e "InstalarYConfigurarMLDonkey ${ColorArgumentos}[IPDesdeLaQueSeVaAControlar]${FinColor}"
      echo ""
      echo "Ejemplo:"
      echo ' InstalarYConfigurarMLDonkey 192.168.0.51'
      echo "------------------------------------------------------------------------------"
      echo ""
      exit $ArgsInsuficientes
    else
      echo ""
      echo "  Instalando el paquete mldonkey-server..."
      echo ""
      apt-get update
      apt-get -y install mldonkey-server
      echo ""
      echo "  Deteninendo el servicio..."
      echo ""
      service mldonkey-server stop
      echo ""
      echo "  Realizando cambios en la configuración..."
      echo ""
      cp /var/lib/mldonkey/downloads.ini /var/lib/mldonkey/downloads.ini.bak
      sed -i -e 's| allowed_ips = \[| allowed_ips = ["127.0.0.1"; "'"$1"'";]|g' /var/lib/mldonkey/downloads.ini
      sed -i -e 's|  "127.0.0.1";]| |g' /var/lib/mldonkey/downloads.ini
      sed -i -e 's| nolimit_ips = \[| nolimit_ips = ["127.0.0.1";]|g' /var/lib/mldonkey/downloads.ini
      echo ""
      echo "  Re-arrancando el servicio..."
      echo ""
      service mldonkey-server start
      echo ""
      echo "  Ejecución del script, finalizada."
      echo "  Ya deberías ser capaz de controlar MLDonkey desde la IP $1."
      echo ""
  fi

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MLDonkey para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 10 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MLDonkey para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 11 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

fi

