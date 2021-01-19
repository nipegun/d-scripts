#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el cliente NoIP en Debian
#--------------------------------------------------------------------------

# Actualizar los paquetes de los repositorios
apt-get update

# Instalar los paquetes necesarios para compilar 
apt-get -y install build-essential gcc make

# Crear la carpeta para guardar el código
mkdir /root/CodFuente/

# Posicionarse en esa carpeta y bajar allí el código fuente
cd /root/CodFuente/
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz

# Descomprimir el archivo con el código
tar xf noip-duc-linux.tar.gz

# Compilar e instalar
cd noip-2.1.9-1/
make
echo ""
echo "------------------------------------------------------------------------"
echo "  A CONTINUACIÓN SE TE PEDIRÁ EL MAIL, LA CONTRASEÑA DE SESIÓN DE NOIP"
echo "  Y EL INTERVALO DE ACTUALIZACIÓN DE LA IP (POR DEFECTO 30 MINUTOS)"
echo "------------------------------------------------------------------------"
echo ""
make install

# Proteger los archivos de configuración
chmod 600 /usr/local/etc/no-ip2.conf
chown root:root /usr/local/etc/no-ip2.conf
chmod 700 /usr/local/bin/noip2
chown root:root /usr/local/bin/noip2

# Lanzar la aplicación
/usr/local/bin/noip2

# Agregar la aplicación a los comandos post arranque
echo "" >> /root/scripts/ComandosPostArranque.sh
echo "# Actualizador NoIP"  >> /root/scripts/ComandosPostArranque.sh
echo "/usr/local/bin/noip2" >> /root/scripts/ComandosPostArranque.sh
