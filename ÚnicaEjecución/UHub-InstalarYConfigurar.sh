#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR EL SERVIDOR DC++ UHUB
#----------------------------------------------------------------------

echo ""
echo "Instalando uHub..."
echo ""

# Agregar el repositorio
# apt-get -y update 2> /dev/mull
# apt-get -y install software-properties-common 2> /dev/mull
# add-apt-repository -y 'deb http://ppa.launchpad.net/tehnick/tehnick/ubuntu vivid main'

# Actualizar
apt-get -y update 2> /dev/mull

# Instalar uHub
apt-get -y install uhub
cp /root/git/uhub/doc/users.conf /etc/uhub/

# Crear el archivo users.conf
echo "# uHub access control lists." > /etc/uhub/users.conf
echo "#" >> /etc/uhub/users.conf
echo "# Syntax: <command> [data]" >> /etc/uhub/users.conf
echo "#" >> /etc/uhub/users.conf
echo "# commands:" >> /etc/uhub/users.conf
echo "# 'user_reg'   - registered user with no particular privileges (data=nick:password)" >> /etc/uhub/users.conf
echo "# 'user_op'    - operator, can kick or ban people (data=nick:password)" >> /etc/uhub/users.conf
echo "# 'user_admin' - administrator, can do everything operators can, and reconfigure the hub (data=nick:password)" >> /etc/uhub/users.conf
echo "# 'deny_nick'  - nick name that is not accepted (example; Administrator)" >> /etc/uhub/users.conf
echo "# 'deny_ip'    - Unacceptable IP (masks can be specified as CIDR: 0.0.0.0/32 will block all IPv4)" >> /etc/uhub/users.conf
echo "# 'ban_nick'   - banned user by nick" >> /etc/uhub/users.conf
echo "# 'ban_cid'    - banned user by cid" >> /etc/uhub/users.conf
echo "" >> /etc/uhub/users.conf
echo "# Administrator" >> /etc/uhub/users.conf
echo "# user_admin    userA:password1" >> /etc/uhub/users.conf
echo "# user_op       userB:password2" >> /etc/uhub/users.conf
echo "" >> /etc/uhub/users.conf
echo "# We don't want users with these names" >> /etc/uhub/users.conf
echo "deny_nick Hub-Security" >> /etc/uhub/users.conf
echo "deny_nick Administrator" >> /etc/uhub/users.conf
echo "deny_nick root" >> /etc/uhub/users.conf
echo "deny_nick admin" >> /etc/uhub/users.conf
echo "deny_nick username" >> /etc/uhub/users.conf
echo "deny_nick user" >> /etc/uhub/users.conf
echo "deny_nick guest" >> /etc/uhub/users.conf
echo "deny_nick operator" >> /etc/uhub/users.conf
echo "" >> /etc/uhub/users.conf
echo "# Banned users" >> /etc/uhub/users.conf
echo "# ban_nick H4X0R" >> /etc/uhub/users.conf
echo "# ban_cid FOIL5EK2UDZYAXT7UIUFEKL4SEBEAJE3INJDKAY" >> /etc/uhub/users.conf
echo "" >> /etc/uhub/users.conf
echo "# ban by ip" >> /etc/uhub/users.conf
echo "#" >> /etc/uhub/users.conf
echo "# to ban by CIDR" >> /etc/uhub/users.conf
echo "# deny_ip 10.21.44.0/24" >> /etc/uhub/users.conf
echo "#" >> /etc/uhub/users.conf
echo "# to ban by IP-range." >> /etc/uhub/users.conf
echo "# deny_ip 10.21.44.7-10.21.44.9" >> /etc/uhub/users.conf
echo "#" >> /etc/uhub/users.conf
echo "# to ban a single IP address" >> /etc/uhub/users.conf
echo "# deny_ip 10.21.44.7" >> /etc/uhub/users.conf
echo "# (which is equivalent to using):" >> /etc/uhub/users.conf
echo "# deny_ip 10.21.44.7/32" >> /etc/uhub/users.conf
echo "" >> /etc/uhub/users.conf
echo "# Will not work, yet" >> /etc/uhub/users.conf
echo "# nat_ip 10.0.0.0/8" >> /etc/uhub/users.conf
echo "# nat_ip 127.0.0.0/8" >> /etc/uhub/users.conf
echo "" >> /etc/uhub/users.conf
echo "# If you have made changes to this file, you must send a HANGUP signal" >> /etc/uhub/users.conf
echo "# to uHub so that it will re-read the configuration files." >> /etc/uhub/users.conf
echo "# For example by invoking: 'killall -HUP uhub'" >> /etc/uhub/users.conf

echo "Bienvenido a este Hub" > /etc/uhub/motd.txt
uhub-passwd /etc/uhub/users.db create
