
#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------
#  Script de NiPeGun para actualizar el php por defecto de Jessie a PHP 7.3
#----------------------------------------------------------------------------

# PHP 5
php5dismod mcrypt
apt-get -y purge php5-common
apt-get -y purge php5-gd
apt-get -y purge php5-curl
apt-get -y purge php5-cli
apt-get -y purge php5-dev
apt-get -y purge php5-json
apt-get -y purge php5-mysql
apt-get -y purge php5-mcrypt
apt-get -y purge php-mbstring
apt-get -y purge php5-intl
apt-get -y purge php5-redis
apt-get -y purge php5-imagick
apt-get -y purge php-pear
apt-get -y purge libapache2-mod-php5
apt-get -y purge phpsysinfo

# PHP 7.3
apt -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.3.list
apt-get -y update
apt-get -y install php7.3-common
apt-get -y install php7.3-gd
apt-get -y install php7.3-curl
apt-get -y install php7.3-cli
apt-get -y install php7.3-dev
apt-get -y install php7.3-json
apt-get -y install php7.3-mysql
apt-get -y install php7.3-mcrypt
apt-get -y install php7.3-mbstring
apt-get -y install php-intl
apt-get -y install php-redis
apt-get -y install php-imagick
apt-get -y install php-pear
apt-get -y install libapache2-mod-php7.3
phpenmod gd
phpenmod curl
phpenmod json
phpenmod mbstring
phpenmod intl
phpenmod redis
phpenmod imagick
sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g' /etc/php/7.3/apache2/php.ini
sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g' /etc/php/7.3/apache2/php.ini
sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php/7.3/apache2/php.ini
sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/7.3/apache2/php.ini

