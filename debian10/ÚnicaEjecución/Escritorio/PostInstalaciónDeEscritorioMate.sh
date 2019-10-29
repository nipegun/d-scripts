#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

apt-get -y install caja-open-terminal
apt-get -y install caja-admin
apt-get -y install firefox-esr-l10n-es-es
apt-get -y install libreoffice-l10n-es
apt-get -y install thunderbird
apt-get -y install thunderbird-l10n-es-es
apt-get -y install lightning-l10n-es-es
apt-get -y install filezilla
apt-get -y install vlc
apt-get -y install virt-viewer
apt-get -y install unrar
apt-get -y install clamav
apt-get -y install clamtk
apt-get -y install audacity
apt-get -y install obs-studio
apt-get -y install openshot
apt-get -y install htop
apt-get -y install remmina
apt-get -y install etherape

apt-get -y remove xterm reportbug blender imagemagick inkscape gnome-disk-utility
apt-get -y autoremove

