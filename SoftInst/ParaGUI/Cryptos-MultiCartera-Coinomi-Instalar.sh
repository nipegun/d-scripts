#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Coinomi en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Coinomi-Instalar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Coinomi-Instalar.sh | bash
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
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Coinomi para Debian 7 (Wheezy)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Coinomi para Debian 8 (Jessie)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Coinomi para Debian 9 (Stretch)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Coinomi para Debian 10 (Buster)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Coinomi para Debian 11 (Bullseye)...${FinColor}"
  echo ""

  # Borrar archivos previos
    rm -rf /root/SoftInst/Coinomi/
    rm -rf /home/$vUsuarioNoRoot/Coinomi/
    rm -f  /home/$vUsuarioNoRoot/.local/share/applications/coinomi-wallet.desktop
    rm -f  /home/$vUsuarioNoRoot/.config/autostart/coinomi-wallet.desktop

  # Determinar URL de descarga del archivo comprimido
    echo ""
    echo "  Determinando la URL de descarga del archivo de instalación de Coinomi..."
    echo ""
    vURLArchivo=$(curl -s https://www.coinomi.com/en/downloads/ | sed 's->->\n-g' | sed 's-"-\n-g' | grep binaries | grep linux64 | sed 's-&#x2F;-/-g')
    echo ""
    echo "    La URL de descarga del archivo es: $vURLArchivo"
    echo ""

  # Descargar archivo comprimido
    echo ""
    echo "  Descargando el archivo..."
    echo ""
    mkdir -p /root/SoftInst/Coinomi 2> /dev/null
    cd /root/SoftInst/Coinomi/
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    #  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    #    echo ""
    #    echo -e "${ColorRojo}  wget no está instalado. Iniciando su instalación...${FinColor}"
    #    echo ""
    #    apt-get -y update && apt-get -y install wget
    #    echo ""
    #  fi
    #wget $vURLArchivo -O /root/SoftInst/Coinomi/Coinomi.tar.gz
    curl -sL $vURLArchivo --output /root/SoftInst/Coinomi/Coinomi.tar.gz

  # Descomprimir archivo
    echo ""
    echo "  Descomprimiento el archivo..."
    echo ""
    # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${ColorRojo}    tar no está instalado. Iniciando su instalación...${FinColor}"
        echo ""
        apt-get -y update
        apt-get -y install tar
        echo ""
      fi
    cd /root/SoftInst/Coinomi/
    tar -xf /root/SoftInst/Coinomi/Coinomi.tar.gz
    rm -rf /root/SoftInst/Coinomi/Coinomi.tar.gz

  # Mover a la carpeta del usuario no-root
    echo ""
    echo "  Moviendo la app a la cuenta del usuario no-root..."
    echo ""
    cp -rf /root/SoftInst/Coinomi/Coinomi/ /home/$vUsuarioNoRoot/
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Coinomi -R

  # Crear el icono
    # Comprobar si el paquete icnsutils está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s icnsutils 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${ColorRojo}    icnsutils no está instalado. Iniciando su instalación...${FinColor}"        echo ""
        apt-get -y update
        apt-get -y install icnsutils
        echo ""
      fi
    icns2png -x /home/$vUsuarioNoRoot/Coinomi/icons.icns -o /home/$vUsuarioNoRoot/Coinomi/
    find /home/$vUsuarioNoRoot/Coinomi/ -maxdepth 1 -mindepth 1 -type f -name "*.png" -exec mv {} /home/$vUsuarioNoRoot/Coinomi/Coinomi.png \;
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Coinomi/Coinomi.png

  # Crear lanzadores
    echo ""
    echo "  Creando lanzadores..."
    echo ""

    mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
    cp -f /home/$vUsuarioNoRoot/Coinomi/coinomi-wallet.desktop                                       /home/$vUsuarioNoRoot/.local/share/applications/coinomi-wallet.desktop
    sed -i -e 's|Exec=Coinomi|Exec=/home/'$vUsuarioNoRoot'/Coinomi/Coinomi|g'                        /home/$vUsuarioNoRoot/.local/share/applications/coinomi-wallet.desktop
    sed -i -e 's|Icon=/ui/static/images/logo.svg|Icon=/home/'$vUsuarioNoRoot'/Coinomi/Coinomi.png|g' /home/$vUsuarioNoRoot/.local/share/applications/coinomi-wallet.desktop
    sed -i -e 's|Name=Coinomi Wallet|Name=MultiCartera Coinomi|g'                                    /home/$vUsuarioNoRoot/.local/share/applications/coinomi-wallet.desktop
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/ -R
    gio set /home/$vUsuarioNoRoot/.local/share/applications/coinomi-wallet.desktop "metadata::trusted" yes

    mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
    cp -f /home/$vUsuarioNoRoot/Coinomi/coinomi-wallet.desktop                                       /home/$vUsuarioNoRoot/.config/autostart/coinomi-wallet.desktop
    sed -i -e 's|Exec=Coinomi|Exec=/home/'$vUsuarioNoRoot'/Coinomi/Coinomi|g'                        /home/$vUsuarioNoRoot/.config/autostart/coinomi-wallet.desktop
    sed -i -e 's|Icon=/ui/static/images/logo.svg|Icon=/home/'$vUsuarioNoRoot'/Coinomi/Coinomi.png|g' /home/$vUsuarioNoRoot/.config/autostart/coinomi-wallet.desktop
    sed -i -e 's|Name=Coinomi Wallet|Name=MultiCartera Coinomi|g'                                    /home/$vUsuarioNoRoot/.config/autostart/coinomi-wallet.desktop
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/ -R
    gio set /home/$vUsuarioNoRoot/.config/autostart/coinomi-wallet.desktop "metadata::trusted" yes

  # Reparar permisos
    echo ""
    echo "  Reparando permisos..."
    echo ""
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/ -R

  # Notificar fin del script
    echo ""
    echo "  Ejecución del script, finalizada..."
    echo ""
    chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/ -R

fi

