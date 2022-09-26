#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar software en el escritorio Mate de Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/GUI/EscritorioMate-InstalarSoftware.sh | bash
#-----------------------------------------------------------------------------------------------------------------------------

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
  echo "--------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de software para el escritorio Mate en Debian 7 (Wheezy)..."
  echo "--------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de software para el escritorio Mate en Debian 8 (Jessie)..."
  echo "--------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de software para el escritorio Mate en Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de software para el escritorio Mate en Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y update

  # Sistema
    apt-get -y install gparted
    apt-get -y install caja-open-terminal
    apt-get -y install caja-admin
    apt-get -y install hardinfo
    apt-get -y install bleachbit

  # Multimedia
    apt-get -y install vlc
    apt-get -y install vlc-plugin-vlsub
    apt-get -y install audacity
    apt-get -y install subtitleeditor
    apt-get -y install easytag
    apt-get -y install openshot

  # Juegos
    apt-get -y install scid
    apt-get -y install scid-rating-data
    apt-get -y install scid-spell-data
    apt-get -y install stockfish
    apt-get -y install dosbox
    apt-get -y install scummvm

  # Fuentes
    apt-get -y install fonts-freefont-ttf
    apt-get -y install fonts-freefont-otf
    apt-get -y install ttf-mscorefonts-installer

  # Redes e internet
    apt-get -y install whois
    apt-get -y install gufw
    apt-get -y install wireshark
    apt-get -y install etherape
      setcap cap_net_raw,cap_net_admin+eip /usr/bin/etherape
    apt-get -y install sshpass
    apt-get -y install virt-viewer
    apt-get -y install firefox-esr-l10n-es-es
    apt-get -y install thunderbird
    apt-get -y install thunderbird-l10n-es-es
    apt-get -y install lightning-l10n-es-es
    apt-get -y install eiskaltdcpp
    apt-get -y install amule
    apt-get -y install chromium
    apt-get -y install chromium-l10n
    apt-get -y install filezilla
    apt-get -y install mumble
    apt-get -y install obs-studio
    apt-get -y install remmina

  # Programación
    apt-get -y install ghex

  # Seguridad
    apt-get -y install clamav
    apt-get -y install clamtk

  # Otros
    apt-get -y install libreoffice-l10n-es
    apt-get -y install unrar
    apt-get -y install htop
    apt-get -y install simple-scan
    apt-get -y install android-tools-adb # Para poder operar con el contenido de los móviles y relojes android
    apt-get -y install android-tools-fastboot
    apt-get -y install pyrenamer # Hay que agregar el repositorio de stretch antes, o instalar gprename, como reemplazo
    apt-get -y install comix

  # Lanzador de chromium para el root
    mkdir -p /root/.local/share/applications/ 2> /dev/null
    echo "[Desktop Entry]"                      > /root/.local/share/applications/chromiumroot.desktop
    echo "Name=Chromium (para root)"           >> /root/.local/share/applications/chromiumroot.desktop
    echo "Comment=Accede a Internet"           >> /root/.local/share/applications/chromiumroot.desktop
    echo "GenericName=Navegador web"           >> /root/.local/share/applications/chromiumroot.desktop
    echo "Exec=/usr/bin/chromium --no-sandbox" >> /root/.local/share/applications/chromiumroot.desktop
    echo "Icon=chromium"                       >> /root/.local/share/applications/chromiumroot.desktop
    echo "Type=Application"                    >> /root/.local/share/applications/chromiumroot.desktop
    echo "StartupNotify=false"                 >> /root/.local/share/applications/chromiumroot.desktop
    echo "StartupWMClass=Code"                 >> /root/.local/share/applications/chromiumroot.desktop
    echo "Categories=Network;WebBrowser;"      >> /root/.local/share/applications/chromiumroot.desktop
    echo "MimeType=text/html;text/xml;application/xhtml_xml;application/x-mimearchive;x-scheme-handler/http;x-scheme-handler/https;" >> /root/.local/share/applications/chromiumroot.desktop
    gio set /root/.local/share/applications/chromiumroot.desktop "metadata::trusted" yes

  /root/scripts/d-scripts/SoftInst/Escritorio/TorBrowser-Instalar.sh

  apt-get -y remove xterm reportbug blender imagemagick inkscape gnome-disk-utility
  apt-get -y autoremove

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de software para el escritorio Mate en Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y update

  # Sistema
    apt-get -y install gparted
    apt-get -y install caja-open-terminal
    apt-get -y install caja-admin
    apt-get -y install hardinfo
    apt-get -y install bleachbit

  # Multimedia
    apt-get -y install vlc
    apt-get -y install vlc-plugin-vlsub
    apt-get -y install audacity
    apt-get -y install subtitleeditor
    apt-get -y install easytag
    apt-get -y install openshot

  # Redes e internet
    apt-get -y install gufw
    apt-get -y install wireshark
    apt-get -y install etherape
    apt-get -y install sshpass
    apt-get -y install virt-viewer
    apt-get -y install whois
    apt-get -y install remmina
    apt-get -y install firefox-esr-l10n-es-es
    apt-get -y install thunderbird
    apt-get -y install thunderbird-l10n-es-es
    apt-get -y install lightning-l10n-es-es
    apt-get -y install eiskaltdcpp
    apt-get -y install amule
    apt-get -y install chromium
    apt-get -y install chromium-l10n
    apt-get -y install filezilla
    apt-get -y install mumble
    apt-get -y install obs-studio

  # Juegos
    apt-get -y install scid
    apt-get -y install scid-rating-data
    apt-get -y install scid-spell-data
    apt-get -y install stockfish
    apt-get -y install dosbox
    apt-get -y install scummvm

  # Fuentes
    apt-get -y install fonts-freefont-ttf
    apt-get -y install fonts-freefont-otf
    apt-get -y install ttf-mscorefonts-installer

  # Programación
    apt-get -y install ghex

  # Seguridad
    apt-get -y install clamav
    apt-get -y install clamtk

  # Otros
    apt-get -y install libreoffice-l10n-es
    apt-get -y install unrar
    apt-get -y install htop
    apt-get -y install simple-scan
    apt-get -y install android-tools-adb # Para poder operar con el contenido de los móviles y relojes android
    apt-get -y install android-tools-fastboot
    apt-get -y install pyrenamer # Hay que agregar el repositorio de stretch antes, o instalar gprename, como reemplazo
    apt-get -y install comix

  # Lanzador de chromium para el root
    mkdir -p /root/.local/share/applications/ 2> /dev/null
    echo "[Desktop Entry]"                      > /root/.local/share/applications/chromiumroot.desktop
    echo "Name=Chromium (para root)"           >> /root/.local/share/applications/chromiumroot.desktop
    echo "Comment=Accede a Internet"           >> /root/.local/share/applications/chromiumroot.desktop
    echo "GenericName=Navegador web"           >> /root/.local/share/applications/chromiumroot.desktop
    echo "Exec=/usr/bin/chromium --no-sandbox" >> /root/.local/share/applications/chromiumroot.desktop
    echo "Icon=chromium"                       >> /root/.local/share/applications/chromiumroot.desktop
    echo "Type=Application"                    >> /root/.local/share/applications/chromiumroot.desktop
    echo "StartupNotify=false"                 >> /root/.local/share/applications/chromiumroot.desktop
    echo "StartupWMClass=Code"                 >> /root/.local/share/applications/chromiumroot.desktop
    echo "Categories=Network;WebBrowser;"      >> /root/.local/share/applications/chromiumroot.desktop
    echo "MimeType=text/html;text/xml;application/xhtml_xml;application/x-mimearchive;x-scheme-handler/http;x-scheme-handler/https;" >> /root/.local/share/applications/chromiumroot.desktop
    gio set /root/.local/share/applications/chromiumroot.desktop "metadata::trusted" yes

  /root/scripts/d-scripts/SoftInst/ParaGUI/TORBrowser-Instalar.sh

  apt-get -y remove xterm reportbug blender imagemagick inkscape gnome-disk-utility
  apt-get -y autoremove

fi

