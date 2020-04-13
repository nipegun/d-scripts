#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------
#  Script de NiPeGun para bloquear la compartición que quiera hacer transmission-daemon
#----------------------------------------------------------------------------------------

echo ""
echo "Bloqueando la compartición de archivos que quiera hacer transmission-daemon..."
echo ""

iptables -A OUTPUT -p udp --sport 51413 -j LOG --log-prefix 'Descartado 51413 OUT UDP '
iptables -A OUTPUT -p udp --sport 51413 -j DROP

iptables -A OUTPUT -p tcp --sport 51413 -j LOG --log-prefix 'Descartado 51413 OUT TCP '
iptables -A OUTPUT -p tcp --sport 51413 -j DROP

echo "" > /etc/rsyslog.d/transmissionout.conf
echo ':msg, startswith, ”Descartado” /var/log/TransmissionOut.log' >> /etc/rsyslog.d/transmissionout.conf
echo "&~" >> /etc/rsyslog.d/transmissionout.conf

rm /var/log/TransmissionOut.log

service rsyslog restart

iptables --list

