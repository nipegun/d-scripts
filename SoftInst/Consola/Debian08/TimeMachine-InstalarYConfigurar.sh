#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR EL SERVIDOR TIMEMACHINE
#------------------------------------------------------------------------

apt-get update
apt-get -y install build-essential devscripts debhelper cdbs autotools-dev dh-buildinfo d-shlibs dh-systemd avahi-daemon
apt-get -y install libdb-dev libwrap0-dev libpam0g-dev libcups2-dev libkrb5-dev libltdl3-dev libgcrypt11-dev libcrack2-dev libavahi-client-dev libldap2-dev libacl1-dev libevent-dev libc6-dev libnss-mdns
apt-get -y autoremove
mkdir /root/git/
cd /root/git/
git clone https://github.com/adiknoth/netatalk-debian
cd netatalk-debian
debuild -b -uc -us
cd ..

ls --color=auto -1 -lh -F

echo ""
echo "--------------------------------------------------"
echo "  A continuación se instalarán  los .deb creados."
echo "--------------------------------------------------"
echo ""
archivo1=$(ls | grep libatalk1)
archivo2=$(ls | grep netatalk*.deb)
dpkg -i $archivo1
dpkg -i $archivo2

echo ""
echo "------------------------------------------"
echo "  Ahora se creará el usuario timemachine."
echo "  Deberás proporcionarle una contraseña."
echo "  Te será requerida dos veces."
echo "------------------------------------------"
echo ""
adduser --home /TimeMachine/ timemachine

echo ""
echo "-----------------------------------------------------"
echo "  Se impedirá la shell para el usuario timemachine."
echo "-----------------------------------------------------"
echo ""
chsh -s /bin/false timemachine

echo ""
echo "-------------------------------------------------------------"
echo "  Se creará la comparticición del disco de red TimeMachine."
echo "-------------------------------------------------------------"
echo ""
mkdir -p /TimeMachine/Copias/
chown -R timemachine:timemachine /TimeMachine/
echo "" >> /etc/netatalk/afp.conf
echo "[TimeMachine]" >> /etc/netatalk/afp.conf
echo "time machine = yes" >> /etc/netatalk/afp.conf
echo "path = /TimeMachine/Copias/" >> /etc/netatalk/afp.conf
echo "vol size limit = 2000000" >> /etc/netatalk/afp.conf
echo "valid users = timemachine" >> /etc/netatalk/afp.conf
systemctl enable netatalk.service
systemctl start netatalk.service
systemctl enable avahi-daemon.service
systemctl start avahi-daemon.service
shutdown -r now

