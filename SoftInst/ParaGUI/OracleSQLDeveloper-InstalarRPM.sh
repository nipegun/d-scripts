#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Oracle SQL Developer en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/OracleSQLDeveloper-InstalarRPM.sh | bash
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
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle SQL Developer para Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle SQL Developer para Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle SQL Developer para Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle SQL Developer para Debian 10 (Buster)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Oracle SQL Developer para Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------------------"
  echo ""

  ## Determinar URL del archivo a descargar
     echo ""
     echo "  Determinando URL del archivo a descargar..."
     echo ""
     ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  curl no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install curl
          echo ""
        fi
     URLDelPaquete=$(curl -s https://www.oracle.com/tools/downloads/sqldev-downloads.html | sed 's-//-\n-g' | sed 's-.zip-.zip\n-g' | sed 's-.rpm-.rpm\n-g' | grep "download.oracle" | grep rpm)
     echo ""
     echo "  La URL del archivo a descargar es: $URLDelPaquete"
     echo ""

  ## Descargar el archivo .rpm
     echo ""
     echo "  Descargando el archivo .rpm..."
     echo ""
     mkdir -p /root/SoftInst/Oracle/SQLDeveloper/ 2> /dev/null
     ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget $URLDelPaquete -O /root/SoftInst/Oracle/SQLDeveloper/sqldeveloper.rpm

  ## Comprobar si el archivo descargado es el correcto
     echo ""
     echo "  Comprobando si el archivo descargado es correcto..."
     echo ""
     if [[ $(find /root/SoftInst/Oracle/SQLDeveloper/ -type f -iname *.rpm -size -10M 2>/dev/null) ]]; then
       echo ""
       echo "  El .rpm descargado ocupa menos de 10 megas"
       echo "  Seguramente la descarga no funcionó correctamente."
       echo ""
       echo "  Descargando directamente el .rpm desde hacks4geeks.com..."
       echo ""
       rm -f /root/SoftInst/Oracle/SQLDeveloper/sqldeveloper.rpm
       cd /root/SoftInst/Oracle/SQLDeveloper/
       wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Oracle/SQLDeveloper/sqldeveloper.rpm
     else
       echo ""
       echo "  El archivo descargado es correcto."
       echo ""
     fi

  ## Convertir el archivo .rpm a .deb
     echo ""
     echo "  Convirtiendo el .rpm a .deb..."
     echo ""
     ## Comprobar si el paquete alien está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s alien 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  alien no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install alien
          echo ""
        fi
     mkdir -p /root/sqldeveloper-21.4.2/debian/sqldeveloper/usr/local/bin/sqldeveloper/
     alien --scripts --verbose -d /root/SoftInst/Oracle/SQLDeveloper/sqldeveloper.rpm

  ## Instlalar OpenJDK 11
     echo ""
     echo "  Instalando OpenJDK 11..."
     echo ""
     apt-get -y update
     apt-get -y install openjdk-11-jdk

  ## Instalar el archivo .deb
     echo ""
     echo "  Instalando el archivo .deb..."
     echo ""
     find /root/SoftInst/Oracle/SQLDeveloper/ -type f -name *.deb -exec dpkg -i {} \;

  ## Crear icono en el menú
     echo ""
     echo "  Creando icono en el menú"
     echo ""
     echo "[Desktop Entry]"                  > ~/.local/share/applications/sqldeveloper.desktop
     echo "Type=Application"                >> ~/.local/share/applications/sqldeveloper.desktop
     echo "Name=Oracle SQL Developer"       >> ~/.local/share/applications/sqldeveloper.desktop
     echo "Exec=sqldeveloper"               >> ~/.local/share/applications/sqldeveloper.desktop
     echo "Icon=/opt/sqldeveloper/icon.png" >> ~/.local/share/applications/sqldeveloper.desktop
     echo "Terminal=false"                  >> ~/.local/share/applications/sqldeveloper.desktop

fi

