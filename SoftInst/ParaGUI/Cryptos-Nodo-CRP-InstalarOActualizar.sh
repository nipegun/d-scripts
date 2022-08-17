#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el messenger de Utopia en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-CRP-InstalarOActualizar.sh | bash
#
#  Cambiando el nombre de usuario
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-CRP-InstalarOActualizar.sh | sed 's/nipegun/usuarionuevo/g' | bash
#----------------------------------------------------------------------------------------------------------------------------

UsuarioNoRoot="nipegun"

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
  echo "------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Utopia Messenger para Debian 7 (Wheezy)..."
  echo "------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Utopia Messenger para Debian 8 (Jessie)..."
  echo "------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Utopia Messenger para Debian 9 (Stretch)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Utopia Messenger para Debian 10 (Buster)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Utopia Messenger para Debian 11 (Bullseye)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  ## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install dialog
       echo ""
     fi
  menu=(dialog --timeout 5 --checklist "¿Donde quieres instalar Utopia Messenger?:" 22 76 16)
    opciones=(1 "Instalar en ubicación por defecto" off
              2 "Instalar en ubicación personalizada" off
              3 "Todavía no disponible" off
              4 "Todavía no disponible" off)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo -e "${ColorVerde}  Instalando Utopia Messenger en ubicación por defecto...${FinColor}"
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

              ## Instalar dependencias
                 echo ""
                 echo "  Instalando dependencias..."
                 echo ""

                 ## Actualizar cache de paquetes
                    apt-get -y update

                 ## libxcb
                    apt-get -y install libxcb-icccm4
                    apt-get -y install libxcb-image0
                    apt-get -y install libxcb-keysyms1
                    apt-get -y install libxcb-randr0
                    apt-get -y install libxcb-render-util0
                    apt-get -y install libxcb-xinerama0
                    apt-get -y install libxcb-xkb1
                    apt-get -y install libxcb-xinput0
                    apt-get -y install libxkbcommon-x11-0

              ## Instalar paquete .deb
                 echo ""
                 echo "  Instalando paquete .deb..."
                 echo ""
                 dpkg -i /root/SoftInst/Cryptos/CRP/utopia-latest.amd64.deb

              ## Fin de la ejecución del script
                 echo ""
                 echo "  Ejecución del script, finalizada."
                 echo ""
                 echo "  Si en algún momento quieres desinstalarlo, ejecuta:"
                 echo "  dpkg -r utopia"
                 echo ""

            ;;

            2)

              echo ""
              echo -e "${ColorVerde}  Instalando Utopia Messenger en ubicación personalizada...${FinColor}"
              echo ""

              # Crear carpeta de descarga
                echo ""
                echo "  Creando carpeta de descarga..."
                echo ""
                mkdir -p /root/SoftInst/Cryptos/CRP/ 2> /dev/null
                rm -rf /root/SoftInst/Cryptos/CRP/*

              # Descargar y descomprimir todos los archivos
                echo ""
                echo "  Descargando el paquete .deb de la instalación..."
                echo ""
                # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo "  wget no está instalado. Iniciando su instalación..."
                    echo ""
                    apt-get -y update && apt-get -y install wget
                    echo ""
                  fi
                cd /root/SoftInst/Cryptos/CRP/
                wget https://update.u.is/downloads/linux/utopia-latest.amd64.deb

                echo ""
                echo "  Extrayendo los archivos de dentro del paquete .deb..."
                echo ""
                # Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo "  binutils no está instalado. Iniciando su instalación..."
                    echo ""
                    apt-get -y update && apt-get -y install binutils
                    echo ""
                  fi
                ar xv /root/SoftInst/Cryptos/CRP/utopia-latest.amd64.deb

                echo ""
                echo "  Descomprimiendo el archivo data.tar.xz..."
                echo ""
                # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo "  tar no está instalado. Iniciando su instalación..."
                    echo ""
                    apt-get -y update && apt-get -y install tar
                    echo ""
                  fi
                tar xfv /root/SoftInst/Cryptos/CRP/data.tar.xz
                echo ""

                # Instalar dependencias
                  echo ""
                  echo "  Instalando dependencias necesarias..."
                  echo ""

                  # Por orden de requerimiento
                    apt-get -y install libxcb-screensaver0
                    apt-get -y install libqt5multimedia5
                    apt-get -y install libqt5printsupport5
                    apt-get -y install libqt5quick5
                    apt-get -y install libqt5x11extras5
                    apt-get -y install libqt5xmlpatterns5
                    apt-get -y install libqt5websockets5
                    apt-get -y install libqt5concurrent5
                    apt-get -y install libqt5sql5
                    #apt-get -y install libqt5multimedia5-plugins
                    #apt-get -y install libgstreamer1.0-dev
                    #apt-get -y install gstreamer1.0-tools
                    #apt-get -y install gstreamer*-plugins-base
                    #apt-get -y install gstreamer*-plugins-good
                    #apt-get -y install gstreamer*-plugins-bad
                    #apt-get -y install gstreamer*-plugins-ugly
                    #apt-get -y install gstreamer1.0-plugins-base-apps

                  # libxcb
                    apt-get -y install libxcb-icccm4
                    apt-get -y install libxcb-image0
                    apt-get -y install libxcb-keysyms1
                    apt-get -y install libxcb-randr0
                    apt-get -y install libxcb-render-util0
                    apt-get -y install libxcb-xinerama0
                    apt-get -y install libxcb-xkb1
                    apt-get -y install libxcb-xinput0
                    apt-get -y install libxkbcommon-x11-0

                  # headless
                    apt-get -y install libx11-xcb1
                    apt-get -y install libgl1-mesa-glx
                    apt-get -y install libpulse-mainloop-glib0
                    apt-get -y install libpulse0
                    apt-get -y install libglib2.0-0
                    apt-get -y install libfontconfig

                    #ln -sf /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms/ /usr/bin/

                # Crear la carpeta para el usuario no root
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
                  rm -f /home/$UsuarioNoRoot/Cryptos/CRP/messenger/package.json
                  rm -f /home/$UsuarioNoRoot/Cryptos/CRP/messenger/version

                # Crear icono para el menu gráfico
                  rm -f /usr/share/applications/utopia.desktop 2> /dev/null
                  rm -f /home/$UsuarioNoRoot/.local/share/applications/crp.desktop 2> /dev/null
                  mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
                  mv /root/SoftInst/Cryptos/CRP/usr/share/applications/utopia.desktop                                 /home/$UsuarioNoRoot/.local/share/applications/
                  mv /root/SoftInst/Cryptos/CRP/usr/share/pixmaps/utopia.png                                          /home/$UsuarioNoRoot/Cryptos/CRP/messenger/
                  sed -i -e "s|/usr/share/pixmaps/utopia.png|/home/$UsuarioNoRoot/Cryptos/CRP/messenger/utopia.png|g" /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop
                  sed -i -e "s|/opt/utopia/messenger|/home/$UsuarioNoRoot/Cryptos/CRP/messenger|g"                    /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop
                  sed -i -e 's|=utopia|=crp GUI|g'                                                                    /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop
                  mv /home/$UsuarioNoRoot/.local/share/applications/utopia.desktop /home/$UsuarioNoRoot/.local/share/applications/crp.desktop
                  gio set /home/$UsuarioNoRoot/.local/share/applications/crp.desktop "metadata::trusted" yes

                # Crear icono para auto-ejecución gráfica
                  mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
                  rm -f /home/$UsuarioNoRoot/.config/autostart/crp.desktop
                  cp /home/$UsuarioNoRoot/.local/share/applications/crp.desktop /home/$UsuarioNoRoot/.config/autostart/crp.desktop
                  gio set /home/$UsuarioNoRoot/.config/autostart/crp.desktop "metadata::trusted" yes

                # Borrar archivos sobrantes
                  #echo ""
                  #echo "  Borrando archivos sobrantes..."
                  #echo ""
                  #rm -rf /root/SoftInst/Cryptos/CRP/opt/
                  #rm -rf /root/SoftInst/Cryptos/CRP/usr/
                  #rm -rf /root/SoftInst/Cryptos/CRP/control.tar.gz
                  #rm -rf /root/SoftInst/Cryptos/CRP/data.tar.xz
                  #rm -rf /root/SoftInst/Cryptos/CRP/debian-binary
                  #rm -rf /root/SoftInst/Cryptos/CRP/utopia-latest.amd64.deb

                # Reparar permisos
                  echo ""
                  echo "  Reparando permisos..."
                  echo ""
                  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/CRP/ -R
                  #find /home/$UsuarioNoRoot/Cryptos/CRP/ -type d -exec chmod 750 {} \;
                  #find /home/$UsuarioNoRoot/Cryptos/CRP/ -type f -iname "*.sh" -exec chmod +x {} \;
                  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.local/share/applications/ -R
                  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.config/autostart/ -R

                echo ""
                echo "  Para debuggear la utilización de los plugins de qt, antes de abrir el messenger, ejecuta:"
                echo ""
                echo "export QT_DEBUG_PLUGINS=1"
                echo ""

                echo ""
                echo "  Para corregir la ubicación de las liberías ejecuta:"
                echo ""
                echo "export LD_LIBRARY_PATH=/home/$UsuarioNoRoot/Cryptos/CRP/messenger/lib"
                echo ""

            ;;

            3)

              echo ""
              echo -e "${ColorVerde}  .${FinColor}"
              echo ""

            ;;

            4)

              echo ""
              echo -e "${ColorVerde}  .${FinColor}"
              echo ""

            ;;
        
          esac

        done

fi

