#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR EL SERVIDOR MUMBLE
#--------------------------------------------------------------------

# Actualizar los repositorios
apt-get -y update

# Instalar el paquete
apt-get -y install mumble-server

# Reconfigurarlo
echo ""
echo "----------------------------------------------------------------------"
echo "  RECONFIGURANDO EL SERVIDOR MUMBLE..."
echo "  TE PEDIRÁ QUE INGRESES DOS VECES LA NUEVA CONTRASEÑA DEL SuperUser"
echo "----------------------------------------------------------------------"
dpkg-reconfigure mumble-server

# Detener el servicio para hacerle cambios a la configuración
service mumble-server stop

# Hacer copia de seguridad del archivo de configuración
cp /etc/mumble-server.ini /etc/mumble-server.ini.bak

# Modificar el archivo de configuración
sed -i -e 's|welcometext="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"|welcometext="<br />Bienvenido al servidor <b>Mumble</b>.<br />"|g' /etc/mumble-server.ini
sed -i -e 's|bandwidth=72000|bandwidth=128000|g' /etc/mumble-server.ini
sed -i -e 's|;bonjour=True|bonjour=True|g' /etc/mumble-server.ini
sed -i -e 's|;sslCert=|;sslCert=/etc/letsencrypt/live/dominioejemplo.com/cert.pem|g' /etc/mumble-server.ini
sed -i -e 's|;sslKey=|;sslKey=/etc/letsencrypt/live/dominioejemplo.com/privkey.pem|g' /etc/mumble-server.ini
sed -i "/;sslKey=/a ;sslCA=/etc/letsencrypt/live/dominioejemplo.com/fullchain.pem" /etc/mumble-server.ini

# Borrar los datos del certificado SSL autogenerado
# Hacer siempre despùés de que se agregue el certificado en /etc/mumble-server.ini
# De hecho, lo correcto, después de modificar /etc/mumble-server.ini, sera hacer:
# service mumble-server stop
# murmurd -wipessl
# pkill murmurd
# service mumble-server start
murmurd -wipessl

# Matar todos los procesos murmurd
pkill murmurd

# Re-arrancar el servicio
service mumble-server start

