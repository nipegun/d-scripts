#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -----------
#  Script de NiPeGun para instalar MySQL Server en Debian
#
# Ejecución remota
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MySQL-Instalar.sh | bash
# -----------

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
  
  echo "  Iniciando el script de instalación de MySQL Server para Debian 7 (Wheezy)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de MySQL Server para Debian 8 (Jessie)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MySQL Server para Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de MySQL Server para Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""

  echo "  Iniciando el script de instalación de MySQL Server para Debian 11 (Bullseye)..."

  echo ""

  mkdir -p /root/SoftInst/MySQLServer/ 2> /dev/null
  cd /root/SoftInst/MySQLServer/
  NomArchivo=$(curl -s https://dev.mysql.com/downloads/repo/apt/ | grep href | grep deb | cut -d'?' -f2 | cut -d'=' -f2 | cut -d'&' -f1)
  ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  wget no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install wget
       echo ""
     fi
  wget https://dev.mysql.com/get/$NomArchivo
  ## Comprobar si el paquete gnupg está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s gnupg 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  gnupg no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install gnupg
       echo ""
     fi
  ## Comprobar si el paquete lsb-release está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s lsb-release 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  lsb-release no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install lsb-release
       echo ""
     fi
  dpkg -i /root/SoftInst/MySQLServer/$NomArchivo
  apt-get update
  apt-get -y install mysql-server
  #mysql-secure-installation
  echo ""
  echo "  Entrando como root a la línea de comandos de MySQL..."
  echo ""
  echo "  Para crear un nuevo usuario ejecuta:"
  echo "  CREATE USER 'username' IDENTIFIED BY 'password';"
  echo ""
  mysql -u root -p
fi

