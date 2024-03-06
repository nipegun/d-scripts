#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar AtomicDEX en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Komodo-Instalar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Komodo-Instalar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo "Este script está preparado para ejecutarse como root y no lo has ejecutado como root." >&2
    exit 1
  fi

ColorAzul="\033[0;34m"
ColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update > /dev/null
    sudo apt-get -y install curl
    echo ""
  fi

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
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de AtomicDEX para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de AtomicDEX para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de AtomicDEX para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de AtomicDEX para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de AtomicDEX para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Komodo Wallet para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Borrar archivos previos
    rm -rf /root/SoftInst/Komodo/
    rm -rf /home/$vUsuarioNoRoot/Komodo/
    rm -f  /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    rm -f  /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop

  # Determinar URL de descarga del archivo comprimido
    echo ""
    echo "  Determinando la URL de descarga del archivo de instalación de Komodo Wallet..."
    echo ""
    vURLArchivo=$(curl -sL curl -sL https://atomicdex.io/en/desktop/ | sed 's->-\n-g' | grep href | grep buntu | cut -d'"' -f2 | head -n1 | sed 's-appimage-portable-g')
    echo ""
    echo "    La URL de descarga del archivo es: $vURLArchivo"
    echo ""

  # Descargar archivo comprimido
    echo ""
    echo "  Descargando el archivo..."
    echo ""
    mkdir -p /root/SoftInst/Komodo/ 2> /dev/null
    cd /root/SoftInst/Komodo/
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  wget no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update && apt-get -y install wget
        echo ""
      fi
    wget $vURLArchivo -O /root/SoftInst/Komodo/Komodo.zip

  # Extraer los archivos de dentro del .zip
    echo ""
    echo "  Extrayendo los archivos de dentro del zip..."
    echo ""
    # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}    unzip no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update && apt-get -y install unzip
        echo ""
      fi
    cd /root/SoftInst/Komodo/
    unzip /root/SoftInst/Komodo/Komodo.zip

  # Crear la carpeta para el usuario no root
    echo ""
    echo "  Creando la carpeta para el usuario no root..."
    echo ""
    mkdir -p /home/$vUsuarioNoRoot/Komodo/ 2> /dev/null
    cp -rf /root/SoftInst/Komodo/AntaraAtomicDexAppDir/usr/*           /home/$vUsuarioNoRoot/Komodo/
    cp     /root/SoftInst/Komodo/AntaraAtomicDexAppDir/dex-logo-64.png /home/$vUsuarioNoRoot/Komodo/logo.png

  # Agregar aplicación al menú
    echo ""
    echo "  Agregando la aplicación gráfica al menú..."
    echo ""
    mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
    cp -f /root/SoftInst/Komodo/AntaraAtomicDexAppDir/dex.desktop                                    /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    sed -i -e 's|Exec=atomicdex-desktop|Exec=/home/'$vUsuarioNoRoot'/Komodo/bin/atomicdex-desktop|g' /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    sed -i -e "s|Icon=dex-logo-64|Icon=/home/$vUsuarioNoRoot/Komodo/logo.png|g"                      /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    sed -i -e "s|Name=atomicdex-desktop|Name=Komodo Wallet|g"                                        /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    sed -i -e "s|Categories=Office;|Categories=Cryptos;|g"                                           /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    sed -i -e "s|Exec=komodo-wallet|Exec=/home/'$vUsuarioNoRoot'/Komodo/bin/komodo-wallet %U|g"      /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/ -R
    gio set /home/$vUsuarioNoRoot/.local/share/applications/komodo-wallet.desktop "metadata::trusted" yes

  # Crear el archivo de auto-ejecución
    echo ""
    echo "  Creando el archivo de autoejecución de komodo-wallet para el escritorio..."
    echo ""
    mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
    cp -f /root/SoftInst/Komodo/AntaraAtomicDexAppDir/dex.desktop                                    /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop
    sed -i -e 's|Exec=atomicdex-desktop|Exec=/home/'$vUsuarioNoRoot'/Komodo/bin/atomicdex-desktop|g' /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop
    sed -i -e "s|Icon=dex-logo-64|Icon=/home/$vUsuarioNoRoot/Komodo/logo.png|g"                      /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop
    sed -i -e "s|Name=atomicdex-desktop|Name=Komodo Wallet|g"                                        /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop
    sed -i -e "s|Categories=Office;|Categories=Cryptos;|g"                                           /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop
    sed -i -e "s|Exec=komodo-wallet|Exec=/home/'$vUsuarioNoRoot'/Komodo/bin/komodo-wallet %U|g"      /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/ -R
    gio set /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop "metadata::trusted" yes

  # Creando el archivo para lanzarlo desde su propia carpeta
    cp /home/$vUsuarioNoRoot/.config/autostart/komodo-wallet.desktop /home/$vUsuarioNoRoot/Komodo/komodo-wallet.desktop

  # Reparar permisos
    echo ""
    echo "  Reparando permisos..."
    echo ""
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Komodo/ -R
    #find /home/$vUsuarioNoRoot/Komodo/ -type d -exec chmod 750 {} \;
    #find /home/$vUsuarioNoRoot/Komodo/ -type f -exec chmod +x {} \;
    find /home/$vUsuarioNoRoot/ -type f -iname "*.sh" -exec chmod +x {} \;



fi

