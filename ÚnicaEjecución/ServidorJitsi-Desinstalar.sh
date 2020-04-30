#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Jitsi en Debian 10
#-------------------------------------------------------------------

apt-get -y remove jitsi-meet
apt-get -y remove prosody
apt-get -y remove jicofo
apt-get -y purge jitsi*
apt-get -y autoremove
rm /etc/jitsi -R
rm /etc/prosody -R
rm -f /etc/apt/sources.list.d/jitsi-stable.list
apt-get -y update > /dev/null
