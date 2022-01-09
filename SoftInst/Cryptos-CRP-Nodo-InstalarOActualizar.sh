#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el messenger de Utopia
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Cryptos-CRP-Nodo-InstalarOActualizar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${ColorVerde}---------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación o actualización del messenger de Utopia...${FinColor}"
echo -e "${ColorVerde}---------------------------------------------------------------------------------${FinColor}"
echo ""

## Crear carpeta de descarga
   echo ""
   echo "  Creando carpeta de descarga..."
   echo ""
   mkdir -p /root/SoftInst/Cryptos/CRP/ 2> /dev/null
   rm -rf /root/SoftInst/Cryptos/CRP/*

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
   cd /root/SoftInst/Cryptos/CRP/
   wget https://update.u.is/downloads/linux/utopia-latest.amd64.deb

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
   ar xv /root/SoftInst/Cryptos/CRP/utopia-latest.amd64.deb

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
   tar xfv /root/SoftInst/Cryptos/CRP/data.tar.xz
   echo ""

## Instalar dependencias
   echo ""
   echo "  Instalando dependencias necesarias..."
   echo ""
   apt-get -y install libpulse-mainloop-glib0
   apt-get -y install gstreamer*-plugins-base
   apt-get -y install gstreamer*-plugins-good
   apt-get -y install gstreamer*-plugins-bad
   apt-get -y install gstreamer*-plugins-ugly
   apt-get -y install libxcb-screensaver0
   apt-get -y install libqt5xmlpatterns5
   apt-get -y install libqt5websockets5
   apt-get -y install libqt5multimedia5
   apt-get -y install libqt5concurrent5 

## Pedir el nombre del usuario no-root
   echo ""
   read -p "Ingresa el nombre del usuario no root: " UsuarioNoRoot

## Crear la carpeta para el usuario no root
   echo ""
   echo "  Creando la carpeta para el usuario no root..."
   echo ""
   rm -rf /home/$UsuarioNoRoot/Cryptos/CRP/messenger/ 2> /dev/null
   mkdir -p /home/$UsuarioNoRoot/Cryptos/CRP/ 2> /dev/null
   mv /root/SoftInst/Cryptos/CRP/opt/utopia/* /home/$UsuarioNoRoot/Cryptos/CRP/messenger/
   mkdir -p /home/$UsuarioNoRoot/Cryptos/CRP/container/
   rm -rf "/home/$UsuarioNoRoot/.local/share/Utopia/Utopia Client/"
   mkdir -p "/home/$UsuarioNoRoot/.local/share/Utopia/Utopia Client/" 2> /dev/null
   echo "[General]"          > "/home/$UsuarioNoRoot/.local/share/Utopia/Utopia Client/messenger.ini"
   echo "languageCode=1034" >> "/home/$UsuarioNoRoot/.local/share/Utopia/Utopia Client/messenger.ini"

## Crear icono para el menu gráfico
   rm -rf /usr/share/applications/utopia.desktop 2> /dev/null
   rm -rf /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop 2> /dev/null
   mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
   mv /root/SoftInst/Cryptos/CRP/usr/share/applications/utopia.desktop                                 /home/$UsuarioNoRoot/.local/share/applications/
   mv /root/SoftInst/Cryptos/CRP/usr/share/pixmaps/utopia.png                                          /home/$UsuarioNoRoot/Cryptos/CRP/messenger/
   sed -i -e "s|/usr/share/pixmaps/utopia.png|/home/$UsuarioNoRoot/Cryptos/CRP/messenger/utopia.png|g" /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop
   sed -i -e "s|/opt/utopia/messenger|/home/$UsuarioNoRoot/Cryptos/CRP/messenger|g"                    /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop
   sed -i -e 's|=utopia|=crp GUI|g'                                                                    /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop
   mv /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop /home/$UsuarioNoRoot/.local/share/applications/crp.desktop
   chown $UsuarioNoRoot:$UsuarioNoRoot      /home/$UsuarioNoRoot/.local/share/applications/crp.desktop

## Crear icono para auto-ejecución gráfica
   mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
   cp /home/$UsuarioNoRoot/.local/share/applications/crp.desktop /home/$UsuarioNoRoot/.config/autostart/crp.desktop

## Borrar archivos sobrantes
   echo ""
   echo "  Borrando archivos sobrantes..."
   echo ""
   rm -rf /root/SoftInst/Cryptos/CRP/opt/
   rm -rf /root/SoftInst/Cryptos/CRP/usr/
   rm -rf /root/SoftInst/Cryptos/CRP/control.tar.gz
   rm -rf /root/SoftInst/Cryptos/CRP/data.tar.xz
   rm -rf /root/SoftInst/Cryptos/CRP/debian-binary
   #rm -rf /root/SoftInst/Cryptos/CRP/utopia-latest.amd64.deb

## Reparar permisos
   echo ""
   echo "  Reparando permisos..."
   echo ""
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/CRP/ -R
   ## Denegar a los otros usuarios del sistema el acceso a la carpeta del usuario
      find /home/$UsuarioNoRoot/Cryptos/CRP/ -type d -exec chmod 750 {} \;
      find /home/$UsuarioNoRoot/Cryptos/CRP/ -type f -iname "*.sh" -exec chmod +x {} \;

