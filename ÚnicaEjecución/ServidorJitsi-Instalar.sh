#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Jitsi en Debian 10
#-------------------------------------------------------------------

HostName=$(cat /etc/hostname)

echo "127.0.0.1 $HostName" >> /etc/hosts

# Instalar la llave del repositorio
wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -

# Crear un archivo de fuentes con el repositorio
sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"

# Actualizar la lista de paquetes:
apt-get -y update

#Instalar la suite
apt-get -y install jitsi-meet

# Si no necesitas la suite completa puedes instalar paquetes individuales
# apt-get -y install jitsi-videobridge
# apt-get -y install jicofo
# apt-get -y install jigasi
