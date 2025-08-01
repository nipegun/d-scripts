#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar software en el escritorio Mate de Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/GUI/Escritorio-Mate-InstalarSoftware.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

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

# Ejecutar comandos dependiendo de la versión de Debian detectada
  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo "  Iniciando el script de instalación de software para el escritorio Mate en Debian 12 (Bookworm)..."
    echo ""

    # Desinstalar cosas específicas de mate-esktop
      apt-get -y remove xterm
      apt-get -y remove reportbug
      apt-get -y remove blender
      apt-get -y remove imagemagick
      apt-get -y remove inkscape
      apt-get -y remove gnome-disk-utility
      apt-get -y autoremove

    # Actualizar el cache de los paquetes
      apt-get -y update

    # Herramientas de terminal
      apt-get -y install openssh-server
      apt-get -y install sshpass
      apt-get -y install whois
      apt-get -y install shellcheck
      apt-get -y install grub2
      apt-get -y install wget
      apt-get -y install curl
      apt-get -y install nmap
      apt-get -y install mc
      apt-get -y install smartmontools
      apt-get -y install coreutils
      apt-get -y install sshpass
      apt-get -y install unrar
      apt-get -y install android-tools-adb # Para poder operar con el contenido de los móviles y relojes android
      apt-get -y install android-tools-fastboot

    # Sistema
      apt-get -y install gparted
      apt-get -y install hardinfo
      apt-get -y install bleachbit

    # Multimedia
      apt-get -y install vlc
      #apt-get -y install vlc-plugin-vlsub
      apt-get -y install audacity
      apt-get -y install subtitleeditor
      apt-get -y install easytag
      apt-get -y install openshot

    # Redes e internet
      apt-get -y install wireshark
      apt-get -y install etherape
        setcap CAP_NET_RAW=pe /usr/bin/etherape
      apt-get -y install virt-viewer
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
      #apt-get -y install telegram-desktop
      apt-get -y install discord

    # Juegos
      apt-get -y install scid
      apt-get -y install scid-rating-data
      apt-get -y install scid-spell-data
      apt-get -y install stockfish
      apt-get -y install dosbox
      apt-get -y install scummvm

    # Fuentes
      apt-get -y install fonts-ubuntu
      apt-get -y install fonts-ubuntu-console
      apt-get -y install fonts-freefont-ttf
      apt-get -y install fonts-freefont-otf
      apt-get -y install ttf-mscorefonts-installer

    # Programación
      apt-get -y install ghex

    # Antivirus
      apt-get -y install clamtk
      apt-get -y install clamav
      apt-get -y install clamav-freshclam
      apt-get -y install clamav-daemon
      mkdir /var/log/clamav/ 2> /dev/null
      #touch /var/log/clamav/freshclam.log
      #chown clamav:clamav /var/log/clamav/freshclam.log
      #chmod 640 /var/log/clamav/freshclam.log
      rm -rf /var/log/clamav/freshclam.log
      freshclam

    # Otros
      apt-get -y install libreoffice-l10n-es
      apt-get -y install unrar
      apt-get -y install htop
      apt-get -y install simple-scan
      apt-get -y install android-tools-adb # Para poder operar con el contenido de los móviles y relojes android
      apt-get -y install android-tools-fastboot
      #apt-get -y install pyrenamer # Hay que agregar el repositorio de stretch antes, o instalar gprename, como reemplazo
      #apt-get -y install comix

    # SmartCards
      apt-get -y install pcscd
      apt-get -y install opensc-pkcs11 
      apt-get -y install libpam-pkcs11

    # Huellas dactilares
      #apt-get -y install libpam-fprintd
      # Borrar todas las huellas registradas en el usuario root (por las dudas)
        #echo ""
        #echo "    Borrando todas las huellas digitales registradas para el usuario root..."
        #echo ""
       #fprintd-delete root --finger right-index-finger
        #fprintd-delete root --finger right-thumb
        #fprintd-delete root --finger right-middle-finger
        #fprintd-delete root --finger right-ring-finger
        #fprintd-delete root --finger right-little-finger
        #fprintd-delete root --finger left-index-finger
        #fprintd-delete root --finger left-thumb
        #fprintd-delete root --finger left-middle-finger
        #fprintd-delete root --finger left-ring-finger
        #fprintd-delete root --finger left-little-finger
        # Registrar las huellas nuevas
        #echo ""
        #echo "    Registrando nuevas huellas digitales..."
        #echo ""
        #fprintd-enroll -f right-index-finger
        #fprintd-enroll -f right-thumb
        #fprintd-enroll -f right-middle-finger
        #fprintd-enroll -f right-ring-finger
        #fprintd-enroll -f right-little-finger
        #fprintd-enroll -f left-index-finger
        #fprintd-enroll -f left-thumb
        #fprintd-enroll -f left-middle-finger
        #fprintd-enroll -f left-ring-finger
        #fprintd-enroll -f left-little-finger
      # Activar autenticación PAM con huella dactilar
        #echo ""
        #echo "    Activando la autenticación PAM mediante huellas digitales..."
        #echo ""
        #pam-auth-update # Marcar fingerprint authentication
      # Comprobar que la autenticación por huella se activó correctamente
        #grep fprint /etc/pam.d/common-auth
        # En caso de que no funcione la autenticación por huella habría entrar como root y purgar fprint 
        # apt-get purge fprintd

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

    # Tor browser
      apt-get -y install torbrowser-launcher

    # Específicas para mate-desktop
      apt-get -y install mate-tweaks
      apt-get -y install caja-open-terminal
      apt-get -y install caja-admin
      apt-get -y install mozo                # Editor del menúde mate
      #apt-get -y install caja-share         # Para compartir carpetas desde el propio caja
      #apt-get -y install gvfs-backends      # Para poder ver las comparticiones de red usando samba

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

