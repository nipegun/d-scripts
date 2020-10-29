#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Sistema
apt-get -y install caja-open-terminal
apt-get -y install caja-admin

# Multimedia
apt-get -y install vlc
apt-get -y install vlc-plugin-vlsub
apt-get -y install audacity
apt-get -y install openshot
apt-get -y install subtitleeditor
apt-get -y install easytag

# Redes
apt-get -y install wireshark
apt-get -y install virt-viewer
apt-get -y install remmina
apt-get -y install etherape
apt-get -y install sshpass

# Juegos
apt-get -y install scid
apt-get -y install scid-rating-data
apt-get -y install scid-spell-data
apt-get -y install stockfish
apt-get -y install dosbox
apt-get -y install scummvm

# Internet
apt-get -y install firefox-esr-l10n-es-es
apt-get -y install thunderbird
apt-get -y install thunderbird-l10n-es-es
apt-get -y install lightning-l10n-es-es
apt-get -y install eiskaltdcpp
apt-get -y install amule
apt-get -y install mumble
apt-get -y install obs-studio
apt-get -y install chromium
apt-get -y install chromium-l10n 
apt-get -y install filezilla

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

/root/scripts/d-scripts/ÚnicaEjecución/debian10/Escritorio/TorBrowser-Instalar.sh

apt-get -y remove xterm reportbug blender imagemagick inkscape gnome-disk-utility
apt-get -y autoremove

