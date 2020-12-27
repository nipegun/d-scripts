#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para actualizar el PHP por defecto de Stretch a la última versión disponible
#--------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

VersPHPDeseada="7.4"
echo -e "  $0${ColorVerde}Instalando la última versión de PHP...${FinColor}"

# Haciendo una lista de los paquetes php actualmente instalados
apt list --installed | grep php > /var/tmp/PHPInstalled.list
sed -i 's/\/.*//' /var/tmp/PHPInstalled.list
sed -i -e 's|phpmyadmin||g' /var/tmp/PHPInstalled.list

echo ""
echo "Los paquetes relacionados con PHP actualmente instalados en el sistema son:"
echo ""
cat /var/tmp/PHPInstalled.list

# Obtener la versión de PHP instalada
NroPHP=$(php -v | head -1 | cut -d " " -f 2 | cut -c 1-3)

rm -rf /var/tmp/PaquetesPHPaBorrar.sh
cp /var/tmp/PHPInstalled.list /var/tmp/PaquetesPHPaBorrar.sh
sed -i -e 's/^/apt-get -y purge /' /var/tmp/PaquetesPHPaBorrar.sh
chmod +x /var/tmp/PaquetesPHPaBorrar.sh

# Creando la lista de paquetes a instalar
rm -rf /var/tmp/PaquetesPHPaInstalar.sh
cp /var/tmp/PHPInstalled.list /var/tmp/PaquetesPHPaInstalar.sh
sed -i -e 's/^/apt-get -y install /' /var/tmp/PaquetesPHPaInstalar.sh
sed -i -e 's|$NroPHP|$VersPHPDeseada|g' /var/tmp/PaquetesPHPaInstalar.sh

# Borrando los paquetes PHP instalados
chmod +x /var/tmp/PaquetesPHPaInstalar.sh
/var/tmp/PaquetesPHPaBorrar.sh
apt-get -y autoremove

apt-get -y install lsb-release apt-transport-https ca-certificates 
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
VersSO=$(lsb_release -sc)
echo "deb https://packages.sury.org/php/ $VersSO main" > /etc/apt/sources.list.d/php.list
apt-get -y update

# Instalando los nuevos paquetes
chmod +x /var/tmp/PaquetesPHPaInstalar.sh
/var/tmp/PaquetesPHPaInstalar.sh

# Otras modificaciones
phpenmod gd
phpenmod curl
phpenmod json
phpenmod mbstring
phpenmod intl
phpenmod redis
phpenmod imagick
sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g' /etc/php/$VersPHPDeseada/apache2/php.ini
sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g' /etc/php/$VersPHPDeseada/apache2/php.ini
sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php/$VersPHPDeseada/apache2/php.ini
sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/$VersPHPDeseada/apache2/php.ini


