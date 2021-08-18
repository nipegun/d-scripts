#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Chia (XCH)
#-----------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="NiPeGun"

echo ""
echo -e "${ColorVerde}----------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Instalando o actualizando messenger de Utopia...${FinColor}"
echo -e "${ColorVerde}----------------------------------------------------${FinColor}"
echo ""

## Crear la carpeta
   rm -rf /root/Cryptos/CRP/messenger/ 2> /dev/null
   mkdir -p /root/Cryptos/CRP/ 2> /dev/null

## Descargar la última versión del messenger
   ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  wget no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update
        apt-get -y install wget
        echo ""
      fi
   echo ""
   echo "  Descargando el archivo .deb..."
   echo ""
   cd /root/Cryptos/CRP/
   wget https://update.u.is/downloads/linux/utopia-latest.amd64.deb

## Extraer los archivos de dentro del archivo .deb
   ## Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  binutils no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update
        apt-get -y install binutils
        echo ""
      fi
   echo ""
   echo "  Descomprimiendo el archivo .deb..."
   echo ""
   ar xv /root/Cryptos/CRP/utopia-latest.amd64.deb

## Extraer los archivos de dentro del archivo data.tar.xz
   ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  tar no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update
        apt-get -y install tar
        echo ""
      fi
   echo ""
   echo "  Descomprimiendo el archivo data.tar.xz..."
   echo ""
   tar xfv /root/Cryptos/CRP/data.tar.xz
   echo ""

## Mover la carpeta de messenger a la raíz de CRP
   mv /root/Cryptos/CRP/opt/utopia/* /root/Cryptos/CRP/
   mkdir -p /root/Cryptos/CRP/container/

## Crear icono para el menu gráfico
   rm -rf /usr/share/applications/utopia.desktop 2> /dev/null
   rm -rf /root/.local/share/applications/utopia.desktop 2> /dev/null
   mkdir -p /root/.local/share/applications/ 2> /dev/null
   mv /root/Cryptos/CRP/usr/share/applications/utopia.desktop    /root/.local/share/applications/
   mv /root/Cryptos/CRP/usr/share/pixmaps/utopia.png             /root/Cryptos/CRP/messenger/
   sed -i -e 's|/usr/share/pixmaps/utopia.png|/root/Cryptos/CRP/messenger/utopia.png|g' /root/.local/share/applications/utopia.desktop
   sed -i -e 's|/opt/utopia/messenger|/root/Cryptos/CRP/messenger|g'                    /root/.local/share/applications/utopia.desktop

## Crear icono para auto-ejecución gráfica
   mkdir -p /root/.config/autostart/ 2> /dev/null
   cp /root/.local/share/applications/utopia.desktop /root/.config/autostart/utopia.desktop

## Borrar archivos sobrantes
   echo ""
   echo "  Borrando archivos sobrantes..."
   echo ""
   rm -rf /root/Cryptos/CRP/opt/
   rm -rf /root/Cryptos/CRP/usr/
   rm -rf /root/Cryptos/CRP/control.tar.gz
   rm -rf /root/Cryptos/CRP/data.tar.xz
   rm -rf /root/Cryptos/CRP/debian-binary
   rm -rf /root/Cryptos/CRP/utopia-latest.amd64.deb

## Crear el archivo de auto-ejecución gráfica
   #echo ""
   #echo "  Creando el archivo de auto-ejecución gráfica..."
   #echo ""
   #mkdir -p /root/.config/autostart/ 2> /dev/null
   #echo "[Desktop Entry]"                                           > /root/.config/autostart/utopia.desktop
   #echo "Name=utopia"                                              >> /root/.config/autostart/utopia.desktop
   #echo "Type=Application"                                         >> /root/.config/autostart/utopia.desktop
   #echo 'Exec=sh -c "/root/Cryptos/CRP/messenger/utopia --url %u"' >> /root/.config/autostart/utopia.desktop
   #echo "Terminal=false"                                           >> /root/.config/autostart/utopia.desktop
   #echo "Hidden=false"                                             >> /root/.config/autostart/utopia.desktop
