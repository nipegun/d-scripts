#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar OBSStudio en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/OBSStudio-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de OBSStudio para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de OBSStudio para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de OBSStudio para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de OBSStudio para Debian 10 (Buster)..."  
  echo ""

  apt-get -y update 2> /dev/null
  apt-get -y install dialog 2> /dev/null

  menu=(dialog --timeout 5 --checklist "Opciones de instalación:" 22 76 16)
    opciones=(
  1 "Instalar desde repositorio" off
              2 "Bajar, compilar e instalar" off
              3 "Bajar, compilar e instalar como portable" off
              4 "Instalar plugin de navegador" off
              5 "Desinstalar OBS compilado" off
)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)

          ;;

          2)
            echo ""
            echo -e "${cColorVerde}  Instalando paquetes necesarios para construir OBS...${cFinColor}"
            echo ""
            apt-get -y update
            apt-get -y install git
            apt-get -y install tar
            apt-get -y install wget
            apt-get -y install build-essential
            apt-get -y install checkinstall
            apt-get -y install cmake
            apt-get -y install libmbedtls-dev
            apt-get -y install libasound2-dev
            apt-get -y install libavcodec-dev
            apt-get -y install libavdevice-dev
            apt-get -y install libavfilter-dev
            apt-get -y install libavformat-dev
            apt-get -y install libavutil-dev
            apt-get -y install libcurl4-openssl-dev
            apt-get -y install libfdk-aac-dev
            apt-get -y install libfontconfig-dev
            apt-get -y install libfreetype6-dev
            apt-get -y install libgl1-mesa-dev
            apt-get -y install libjack-jackd2-dev
            apt-get -y install libjansson-dev
            apt-get -y install libluajit-5.1-dev
            apt-get -y install libpulse-dev
            apt-get -y install libqt5x11extras5-dev
            apt-get -y install libspeexdsp-dev
            apt-get -y install libswresample-dev
            apt-get -y install libswscale-dev
            apt-get -y install libudev-dev
            apt-get -y install libv4l-dev
            apt-get -y install libvlc-dev
            apt-get -y install libx11-dev
            apt-get -y install libx264-dev
            apt-get -y install libxcb-shm0-dev
            apt-get -y install libxcb-xinerama0-dev
            apt-get -y install libxcomposite-dev
            apt-get -y install libxinerama-dev
            apt-get -y install pkg-config
            apt-get -y install python3-dev
            apt-get -y install qtbase5-dev
            apt-get -y install libqt5svg5-dev
            apt-get -y install swig
            apt-get -y install libxcb-randr0-dev
            apt-get -y install libxcb-xfixes0-dev
            apt-get -y install libx11-xcb-dev
            apt-get -y install libxcb1-dev
            apt-get -y install libxss-dev

            mkdir -p /root/CodFuente/OBS
            cd /root/CodFuente/OBS
            wget --no-check-certificate https://cdn-fastly.obsproject.com/downloads/cef_binary_3770_linux64.tar.bz2
            tar -xjf ./cef_binary_3770_linux64.tar.bz2
            rm -rf /root/CodFuente/OBS/cef_binary_3770_linux64.tar.bz2
            git clone --recursive https://github.com/obsproject/obs-studio.git
            mkdir -p /root/CodFuente/OBS/obs-studio/build
            cd /root/CodFuente/OBS/obs-studio/build
            cmake -DUNIX_STRUCTURE=1 -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_BROWSER=ON -DCEF_ROOT_DIR="../../cef_binary_3770_linux64" ..
            make -j4
            #checkinstall --default --pkgname=obs-studio --fstrans=no --backup=no --pkgversion="$(date +%Y%m%d)-git" --deldoc=yes
            make install
            echo ""
            echo "Parcheando el link de ejecución para indicarle que arranque siempre con LibGL..."
            echo ""
            sed -i -e 's|Exec=obs|Exec=LIBGL_ALWAYS_SOFTWARE=1 obs|g' /usr/share/applications/com.obsproject.Studio.desktop

          ;;

          3)

            echo ""
            echo -e "${cColorVerde}  Instalando paquetes necesarios para construir OBS...${cFinColor}"
            echo ""
            apt-get -y update
            apt-get -y install git
            apt-get -y install tar
            apt-get -y install wget
            apt-get -y install build-essential
            apt-get -y install checkinstall
            apt-get -y install cmake
            apt-get -y install libmbedtls-dev
            apt-get -y install libasound2-dev
            apt-get -y install libavcodec-dev
            apt-get -y install libavdevice-dev
            apt-get -y install libavfilter-dev
            apt-get -y install libavformat-dev
            apt-get -y install libavutil-dev
            apt-get -y install libcurl4-openssl-dev
            apt-get -y install libfdk-aac-dev
            apt-get -y install libfontconfig-dev
            apt-get -y install libfreetype6-dev
            apt-get -y install libgl1-mesa-dev
            apt-get -y install libjack-jackd2-dev
            apt-get -y install libjansson-dev
            apt-get -y install libluajit-5.1-dev
            apt-get -y install libpulse-dev
            apt-get -y install libqt5x11extras5-dev
            apt-get -y install libspeexdsp-dev
            apt-get -y install libswresample-dev
            apt-get -y install libswscale-dev
            apt-get -y install libudev-dev
            apt-get -y install libv4l-dev
            apt-get -y install libvlc-dev
            apt-get -y install libx11-dev
            apt-get -y install libx264-dev
            apt-get -y install libxcb-shm0-dev
            apt-get -y install libxcb-xinerama0-dev
            apt-get -y install libxcomposite-dev
            apt-get -y install libxinerama-dev
            apt-get -y install pkg-config
            apt-get -y install python3-dev
            apt-get -y install qtbase5-dev
            apt-get -y install libqt5svg5-dev
            apt-get -y install swig
            apt-get -y install libxcb-randr0-dev
            apt-get -y install libxcb-xfixes0-dev
            apt-get -y install libx11-xcb-dev
            apt-get -y install libxcb1-dev
            apt-get -y install libxss-dev
            mkdir -p /root/CodFuente/OBS
            cd /root/CodFuente/OBS
            wget https://cdn-fastly.obsproject.com/downloads/cef_binary_4280_linux64.tar.bz2
            tar -xjf ./cef_binary_4280_linux64.tar.bz2
            rm -rf /root/CodFuente/OBS/cef_binary_4280_linux64.tar.bz2
            rm -rf /root/CodFuente/OBS/obs-studio/
            git clone --recursive https://github.com/obsproject/obs-studio.git
            mkdir -p /root/CodFuente/OBS/obs-studio/build
            cd /root/CodFuente/OBS/obs-studio/build
            cmake -DUNIX_STRUCTURE=0 -DCMAKE_INSTALL_PREFIX="${HOME}/obs-studio-portable" -DBUILD_BROWSER=ON -DCEF_ROOT_DIR="../../cef_binary_4280_linux64" ..
            make -j4
            make install
          
          ;;

          4)

            apt-get -y install curl wget
            UltVers=$(curl -sL https://github.curl https://github.com/bazukas/obs-linuxbrowser/releases/latest | cut -d'"' -f2 | cut -d'/' -f8)
            Archivo=$(curl -sL https://github.com/bazukas/obs-linuxbrowser/releases/tag/$UltVers | grep tgz | cut -d'"' -f2 | grep tgz)
            mkdir -p /root/paquetes/obs-linuxbrowser
            cd /root/paquetes/obs-linuxbrowser
            rm -rf /root/paquetes/obs-linuxbrowser/*
            wget --no-check-certificate https://github.com$Archivo
            find /root/paquetes/obs-linuxbrowser/ -type f -name "*.tgz" -exec mv {} /root/paquetes/obs-linuxbrowser/$UltVers.tgz \;
            tar zxvf /root/paquetes/obs-linuxbrowser/$UltVers.tgz
            echo 'LinuxBrowser="Navegador"'                                   > /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'LocalFile="Archivo local"'                                 >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'URL="URL"'                                                 >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'Width="Ancho"'                                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'Height="Alto"'                                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'FPS="FPS"'                                                 >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'ReloadPage="Recargar página"'                              >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'ReloadOnScene="Recargar al activar"'                       >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'FlashPath="Flash Plugin Path"'                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'FlashVersion="Versión del plugin de Flash"'                >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'RestartBrowser="Reiniciar navegador"'                      >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'StopOnHide="Parar el navegador cuando no se muestra"'      >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'CustomCSS="CSS personalizado"'                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'CSSFileReset="Reset CSS file path"'                        >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'CustomJS="JavaScript personalizado"'                       >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'JSFileReset="Reset JS file path"'                          >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'CommandLineArguments="Argumentos de la línea de comandos"' >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'HideScrollbars="Ocultar las barras de desplazamiento"'     >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'Zoom="Zoom"'                                               >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'ScrollVertical="Desplazamiento vertical"'                  >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            echo 'ScrollHorizontal="Desplazamiento horizontal"'              >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
            mkdir -p /root/.config/obs-studio/plugins/obs-linuxbrowser/
            cp -r /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/ /root/.config/obs-studio/plugins/
            
            echo ""
            echo -e "${cColorVerde}-----------------------------------------------------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Ejecución del script, finalizada.${cFinColor}"
            echo -e ""
            echo -e "${cColorVerde}  Si queres tener el plugin disponible para otro usuario que no sea el root${cFinColor}"
            echo -e "${cColorVerde}copia la carpeta /root/.config/obs-studio/plugins dentro de la carpeta${cFinColor}"
            echo -e "${cColorVerde}del usuario correspondiente, siguiendo la estructura de carpetas correcta.${cFinColor}"
            echo -e "${cColorVerde}-----------------------------------------------------------------------------${cFinColor}"
            echo ""

          ;;

          5)

            rm -rf /bin/obs
            rm -rf /bin/obs-ffmpeg-mux
            rm -rf /lib/libobs.so
            rm -rf /lib/libobs.so.0
            rm -rf /lib/libobs-frontend-api.so
            rm -rf /lib/libobs-frontend-api.so.0
            rm -rf /lib/libobs-frontend-api.so.0.0
            rm -rf /lib/libobsglad.so
            rm -rf /lib/libobsglad.so.0
            rm -rf /lib/libobs-opengl.so
            rm -rf /lib/libobs-opengl.so.0
            rm -rf /lib/libobs-opengl.so.0.0
            rm -rf /lib/libobs-scripting.so
            rm -rf /lib/obs-plugins
            rm -rf /lib/x86_64-linux-gnu/pkgconfig/libobs.pc
            rm -rf /lib/x86_64-linux-gnu/obs-scripting
            rm -rf /usr/include/obs
            rm -rf /usr/lib/cmake/LibObs
            rm -rf /usr/lib/obs-scripting
            rm -rf /usr/share/obs
            rm -rf /usr/share/applications/com.obsproject.Studio.desktop

          ;;

        esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de OBSStudio para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
