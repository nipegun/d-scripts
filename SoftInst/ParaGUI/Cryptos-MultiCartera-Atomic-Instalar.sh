#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Atomic en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Atomic-Instalar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Atomic-Instalar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo "Este script está preparado para ejecutarse como root y no lo has ejecutado como root." >&2
    exit 1
  fi

ColorAzul="\033[0;34m"
ColorAzulClaro="\033[1;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${ColorRojo}  curl no está instalado. Iniciando su instalación...${FinColor}"
    echo ""
    sudo apt-get -y update > /dev/null
    sudo apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
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
  echo -e "${ColorAzulClaro}Iniciando el script de instalación de Atomic para Debian 7 (Wheezy)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${ColorAzulClaro}Iniciando el script de instalación de Atomic para Debian 8 (Jessie)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${ColorAzulClaro}Iniciando el script de instalación de Atomic para Debian 9 (Stretch)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${ColorAzulClaro}Iniciando el script de instalación de Atomic para Debian 10 (Buster)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${ColorAzulClaro}Iniciando el script de instalación de Atomic para Debian 11 (Bullseye)...${FinColor}"
  echo ""

  # Borrar archivos previos
    rm -rf /root/SoftInst/Atomic/
    rm -rf /home/$vUsuarioNoRoot/Atomic/
    rm -f  /home/$vUsuarioNoRoot/.local/share/applications/Atomic.desktop
    rm -f  /home/$vUsuarioNoRoot/.config/autostart/Atomic.desktop

  # Determinar URL de descarga del archivo comprimido
    echo ""
    echo "  Determinando la URL de descarga del archivo de instalación de Atomic Wallet..."
    echo ""
    vURLArchivo=$(curl -s https://get.atomicwallet.io/download/ | grep ".deb" | grep href | grep -v sum | grep -v "atomicwallet.deb" | tail -n1 | cut -d'"' -f2 | cut -d'/' -f2)
    echo ""
    echo "    La URL de descarga del archivo es: https://get.atomicwallet.io/download/$vURLArchivo"
    echo ""

  # Descargar archivo comprimido
    echo ""
    echo "  Descargando el archivo..."
    echo ""
    mkdir -p /root/SoftInst/AtomicWallet 2> /dev/null
    cd /root/SoftInst/AtomicWallet
    curl -s https://get.atomicwallet.io/download/$vURLArchivo --output /root/SoftInst/AtomicWallet/AtomicWallet.deb

  # Extraer los archivos de dentro del .deb
    echo ""
    echo "  Extrayendo los archivos de dentro del paquete .deb..."
    echo ""
    # Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${ColorRojo}  binutils no está instalado. Iniciando su instalación...${FinColor}"
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install binutils
        echo ""
      fi
    cd /root/SoftInst/AtomicWallet/
    ar xv /root/SoftInst/AtomicWallet/AtomicWallet.deb

  # Descomprimir el archivo data.tar.xz
    echo ""
    echo "  Descomprimiendo el archivo data.tar.xz..."
    echo ""
    # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${ColorRojo}    tar no está instalado. Iniciando su instalación...${FinColor}"
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install tar
        echo ""
      fi
    tar -xvf /root/SoftInst/AtomicWallet/data.tar.xz
    echo ""

  # Crear la carpeta para el usuario no root
    echo ""
    echo "  Creando la carpeta para el usuario no root..."
    echo ""
    mkdir -p /home/$vUsuarioNoRoot/Atomic/ 2> /dev/null
    cp -rf '/root/SoftInst/AtomicWallet/opt/Atomic Wallet/'* /home/$vUsuarioNoRoot/Atomic/
    cp /root/SoftInst/AtomicWallet/usr/share/icons/hicolor/256x256/apps/atomic.png /home/$vUsuarioNoRoot/Atomic/atomic.png

  # Agregar aplicación al menú
    echo ""
    echo "  Agregando la aplicación gráfica al menú..."
    echo ""
    mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
    cp -f /root/SoftInst/AtomicWallet/usr/share/applications/atomic.desktop                           /home/$vUsuarioNoRoot/.local/share/applications/atomic-wallet.desktop
    sed -i -e 's|Exec="/opt/Atomic Wallet/atomic" %U|Exec=/home/'$vUsuarioNoRoot'/Atomic/atomic %U|g' /home/$vUsuarioNoRoot/.local/share/applications/atomic-wallet.desktop
    sed -i -e "s|Icon=atomic|Icon=/home/$vUsuarioNoRoot/Atomic/atomic.png|g"                          /home/$vUsuarioNoRoot/.local/share/applications/atomic-wallet.desktop
    gio set /home/$vUsuarioNoRoot/.local/share/applications/atomic-wallet.desktop "metadata::trusted" yes

  # Crear el archivo de auto-ehecución
    echo ""
    echo "  Creando el archivo de autoejecución de chia-blockchain para el escritorio..."
    echo ""
    mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
    cp -f /root/SoftInst/AtomicWallet/usr/share/applications/atomic.desktop                           /home/$vUsuarioNoRoot/.config/autostart/atomic-wallet.desktop
    sed -i -e 's|Exec="/opt/Atomic Wallet/atomic" %U|Exec=/home/'$vUsuarioNoRoot'/Atomic/atomic %U|g' /home/$vUsuarioNoRoot/.config/autostart/atomic-wallet.desktop
    sed -i -e "s|Icon=atomic|Icon=/home/$vUsuarioNoRoot/Atomic/atomic.png|g"                          /home/$vUsuarioNoRoot/.config/autostart/atomic-wallet.desktop
    gio set /home/$vUsuarioNoRoot/.config/autostart/atomic-wallet.desktop "metadata::trusted" yes

  # Reparar permisos
    echo ""
    echo "  Reparando permisos..."
    echo ""
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Atomic/ -R
    #find /home/$vUsuarioNoRoot/Atomic/ -type d -exec chmod 750 {} \;
    #find /home/$vUsuarioNoRoot/Atomic/ -type f -exec chmod +x {} \;
    find /home/$vUsuarioNoRoot/ -type f -iname "*.sh" -exec chmod +x {} \;
    chown root:root /home/$vUsuarioNoRoot/Atomic/chrome-sandbox
    chmod 4755      /home/$vUsuarioNoRoot/Atomic/chrome-sandbox

fi
