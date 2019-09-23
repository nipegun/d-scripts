#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

apt-get -y install thunderbird unrar
apt-get -y install libreoffice-l10n-es firefox-esr-l10n-es-es thunderbird-l10n-es-es lightning-l10n-es-es
apt-get -y install filezilla vlc clamav clamtk audacity obs-studio openshot htop remmina etherape
apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es thunderbird-l10n-es-es lightning-l10n-es-es
apt-get -y remove xterm reportbug blender imagemagick inkscape gnome-disk-utility
apt-get -y autoremove

