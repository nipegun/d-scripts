#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------
#  Script de NiPeGun para bloquear todo el tráfico saliente de transmission-daemon
#-----------------------------------------------------------------------------------

echo ""
echo "Bloqueando todo el tráfico saliente de transmission-daemon..."
echo ""
idu=$(id -u debian-transmission)
iptables -A OUTPUT -m owner --uid-owner $idu -p tcp --sport 9091 -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner $idu -j LOG --log-prefix 'Descartado OUT por UID '
iptables -A OUTPUT -m owner --uid-owner $idu -j DROP

# No debería ser necesario bloquear por id de grupo, pero aquí lo dejo por las dudas
#idg=$(id -g debian-transmission)
#iptables -A OUTPUT -m owner --gid-owner $idg -j LOG --log-prefix 'Descartado OUT por GID '
#iptables -A OUTPUT -m owner --gid-owner $idg -j DROP

echo "" > /etc/rsyslog.d/transmissionout.conf
echo ':msg, startswith, ”Descartado” /var/log/TransmissionOut.log' >> /etc/rsyslog.d/transmissionout.conf
echo "&~" >> /etc/rsyslog.d/transmissionout.conf

rm /var/log/TransmissionOut.log

service rsyslog restart

iptables --list

