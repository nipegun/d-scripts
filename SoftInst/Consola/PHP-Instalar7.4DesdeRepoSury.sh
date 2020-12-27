#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------
#  Script de NiPeGun para instalar PHP 7.4 desde el repo de Sury.org
#
#  Antes de ejecutar este script recuerda ejecutar:
#   /root/scripts/d-scripts/SoftInst/Consola/PHP-DesinstalarPorCompleto.sh
#---------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo -e "${ColorVerde}Instalando PHP 7.4 desde el repo de sury.org...${FinColor}"

# Agregar el repositorio de sury.org
apt-get -y install lsb-release apt-transport-https ca-certificates 
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
VersSO=$(lsb_release -sc)
echo "deb https://packages.sury.org/php/ $VersSO main" > /etc/apt/sources.list.d/php.list
apt-get -y update

# Instalar paquetes
apt-get -y install libapache2-mod-php7.4
apt-get -y install php7.4-cli
apt-get -y install php7.4-common
apt-get -y install php7.4-curl
apt-get -y install php7.4-dev
apt-get -y install php7.4-gd
apt-get -y install php7.4-imagick
apt-get -y install php7.4-intl
apt-get -y install php7.4-json
apt-get -y install php7.4-mbstring
apt-get -y install php7.4-mcrypt
apt-get -y install php7.4-mysql
apt-get -y install php7.4-pear
apt-get -y install php7.4-redis
apt-get -y install php7.4-xml
phpenmod curl
phpenmod gd
phpenmod intl
phpenmod imagick
phpenmod json
phpenmod mbstring
phpenmod redis
phpenmod mcrypt
cp /etc/php/7.4/apache2/php.ini /etc/php/7.4/apache2/php.ini.bak
sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g' /etc/php/7.4/apache2/php.ini
sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g' /etc/php/7.4/apache2/php.ini
sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php/7.4/apache2/php.ini
sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/7.4/apache2/php.ini

