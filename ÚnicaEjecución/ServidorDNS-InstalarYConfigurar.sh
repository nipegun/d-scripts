#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un servidor DNS en Debian 9
#----------------------------------------------------------------------------

echo ""
echo "Instalando paquetes necesarios..."
echo ""
apt-get -y update
apt-get -y install bind9 dnsutils

echo ""
echo "Reiniciando el servidor DNS..."
echo ""
service bind9 restart

echo ""
echo "Realizando cambios en la configuración..."
echo ""
sed -i "1s|^|nameserver 127.0.0.1\n|" /etc/resolv.conf
sed -i -e 's|// forwarders {|forwarders {|g' /etc/bind/named.conf.options
sed -i "/0.0.0.0;/c\1.1.1.1;" /etc/bind/named.conf.options
sed -i -e 's|// };|};|g' /etc/bind/named.conf.options

echo ""
echo "Creando zona DNS de prueba..."
echo ""
echo 'zone "prueba.com" {' >> /etc/bind/named.conf.local
echo "  type master;" >> /etc/bind/named.conf.local
echo '  file "/etc/bind/db.prueba.com";' >> /etc/bind/named.conf.local
echo "};" >> /etc/bind/named.conf.local

echo ""
echo "Creando la base de datos de prueba..."
echo ""
cp /etc/bind/db.local /etc/bind/db.prueba.com
echo -e "router\tIN\tA\t192.168.1.1" >> /etc/bind/db.prueba.com
echo -e "servidor\tIN\tA\t192.168.1.10" >> /etc/bind/db.prueba.com
echo -e "impresora\tIN\tA\t192.168.1.11" >> /etc/bind/db.prueba.com

#echo ""
#echo "Corrigiendo los posibles errores de IPv6..."
#echo ""
sed -i -e 's|RESOLVCONF=no|RESOLVCONF=yes|g' /etc/default/bind9
sed -i -e 's|OPTIONS="-u bind"|OPTIONS="-4 -u bind"|g' /etc/default/bind9

echo ""
echo "Volviendo a reiniciar el servidor DNS..."
echo ""
service bind9 restart

echo ""
echo "Mostrando el estado del servidor DNS..."
echo ""
service bind9 status

