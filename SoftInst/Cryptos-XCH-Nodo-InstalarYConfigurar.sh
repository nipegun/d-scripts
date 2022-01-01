#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Chia (XCH)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Cryptos-XCH-Nodo-InstalarYConfigurar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de la cadena de bloques de XCH...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo ""

## Crear carpeta de descarga
   echo ""
   echo "  Creando carpeta de descarga..."
   echo ""
   mkdir -p /root/SoftInst/Cryptos/XCH/ 2> /dev/null
   rm -rf /root/SoftInst/Cryptos/XCH/*

## Descargar y descomprimir todos los archivos
   echo ""
   echo "  Descargando el paquete .deb de la instalación..."
   echo ""
   ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  wget no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install wget
        echo ""
      fi
   cd /root/SoftInst/Cryptos/XCH/
   wget https://download.chia.net/latest/x86_64-Ubuntu-gui -O /root/SoftInst/Cryptos/XCH/chia-blockchain.deb

   echo ""
   echo "  Extrayendo los archivos de dentro del paquete .deb..."
   echo ""
   ## Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  binutils no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install binutils
        echo ""
      fi
   ar xv /root/SoftInst/Cryptos/XCH/chia-blockchain.deb

   echo ""
   echo "  Descomprimiendo el archivo data.tar.xz..."
   echo ""
   ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  tar no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install tar
        echo ""
      fi
   tar -xvf /root/SoftInst/Cryptos/XCH/data.tar.xz
   echo ""

## Instalar dependencias necesarias
   echo ""
   echo "  Instalando dependencias necesarias..."
   echo ""
   apt-get -y install libgtk-3-0
   apt-get -y install libnotify4
   apt-get -y install libnss3
   apt-get -y install libxtst6
   apt-get -y install xdg-utils
   apt-get -y install libatspi2.0-0
   apt-get -y install libdrm2
   apt-get -y install libgbm1
   apt-get -y install libxcb-dri3-0
   apt-get -y install kde-cli-tools
   apt-get -y install kde-runtime
   apt-get -y install trash-cli
   apt-get -y install libglib2.0-bin
   apt-get -y install gvfs-bin
   #dpkg -i /root/SoftInst/Cryptos/XCH/chia-blockchain.deb
   #echo ""
   #echo "Para ver que archivos instaló el paquete, ejecuta:"
   #echo ""
   #echo "dpkg-deb -c /root/SoftInst/Cryptos/XCH/chia-blockchain.deb"

## Crear la carpeta para el usuario no root
   echo ""
   echo "  Creando la carpeta para el usuario no root..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/Cryptos/XCH/ 2> /dev/null
   rm -rf /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/ 2> /dev/null
   mv /root/SoftInst/Cryptos/XCH/usr/lib/chia-blockchain/ /home/$UsuarioNoRoot/Cryptos/XCH/
   rm -rf /root/SoftInst/Cryptos/XCH/usr/
   #mkdir -p /home/$UsuarioNoRoot/.config/Chia Blockchain/ 2> /dev/null
   #echo '{"spellcheck":{"dictionaries":["es-ES"],"dictionary":""}}' > /home/$UsuarioNoRoot/.config/Chia Blockchain/Preferences

## Borrar archivos sobrantes
   echo ""
   echo "  Borrando archivos sobrantes..."
   echo ""
   #rm -rf /root/SoftInst/Cryptos/XCH/debian-binary
   #rm -rf /root/SoftInst/Cryptos/XCH/control.tar.xz
   #rm -rf /root/SoftInst/Cryptos/XCH/data.tar.xz

## Agregar aplicación al menú
   echo ""
   echo "  Agregando la aplicación gráfica al menú..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
   echo "[Desktop Entry]"                                                 > /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   echo "Name=Chia GUI"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   echo "Type=Application"                                               >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xch-gui-iniciar.sh" >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   echo "Terminal=false"                                                 >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   echo "Hidden=false"                                                   >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   echo "Categories=Cryptos"                                             >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop
   #echo "Icon="                                                         >> /home/$UsuarioNoRoot/.local/share/applications/chia.desktop

## Crear el archivo de auto-ehecución
   echo ""
   echo "  Creando el archivo de autoejecución de chia-blockchain para el escritorio..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
   echo "[Desktop Entry]"                                                 > /home/$UsuarioNoRoot/.config/autostart/chia.desktop
   echo "Name=Chia GUI"                                                  >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
   echo "Type=Application"                                               >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xch-gui-iniciar.sh" >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
   echo "Terminal=false"                                                 >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop
   echo "Hidden=false"                                                   >> /home/$UsuarioNoRoot/.config/autostart/chia.desktop

## Instalar los c-scripts
   echo ""
   echo "  Instalando los c-scripts..."
   echo ""
   su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
   find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

## Parar el daemon
   echo ""
   echo "  Parando el daemon (si es que está activo)..."
   echo ""
   chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/xch-daemon-parar.sh
   su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/xch-daemon-parar.sh"

## Reparar permisos
   echo ""
   echo "  Reparando permisos..."
   echo ""
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
   ## Denegar a los otros usuarios del sistema el acceso a la carpeta del usuario 
      find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
      find /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/ -type f -exec chmod +x {} \;
      find /home/$UsuarioNoRoot/                             -type f -iname "*.sh" -exec chmod +x {} \;
   ## Reparar permisos para permitir la ejecución de la cartera de Chia
      chown root:root /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox
      chmod 4755 /home/$UsuarioNoRoot/Cryptos/XCH/chia-blockchain/chrome-sandbox

