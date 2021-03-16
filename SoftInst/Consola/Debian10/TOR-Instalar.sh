#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------
#  Script de NiPeGun para instalar TOR en Debian
#-------------------------------------------------

apt-get -y update
apt-get -y install tor
cp /etc/tor/torrc /etc/tor/torrc.bak
echo "SocksPort 9050"                            > /etc/tor/torrc
echo "Log notice file /var/log/tor/notices.log" >> /etc/tor/torrc
echo "Log debug file /var/log/tor/debug.log"    >> /etc/tor/torrc
echo "RunAsDaemon 1"                            >> /etc/tor/torrc

systemctl reload tor.service
systemctl restart tor.service
