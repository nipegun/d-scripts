#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------
#  Script de NiPeGun para actualizar de Debian 9 a Debian 10
#-------------------------------------------------------------

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
dpkg -C
apt-mark showhold
cp /etc/apt/sources.list /etc/apt/sources.list.deb9
sed -i 's|stretch|buster|g' /etc/apt/sources.list
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get autoremove
shutdown -r now

