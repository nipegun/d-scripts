#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar PHP 8.0 desde el repo de Sury.org
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/PHP-Instalar8.0-DesdeRepoSury.sh | bash
#
#  Antes de ejecutar este script recuerda ejecutar:
#   /root/scripts/d-scripts/SoftInst/Consola/PHP-DesinstalarPorCompleto.sh
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorVerde}Instalando PHP 8.0 desde el repo de sury.org...${cFinColor}"
echo ""

# Agregar el repositorio de sury.org
apt-get -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
VersSO=$(lsb_release -sc)
echo "deb https://packages.sury.org/php/ $VersSO main" > /etc/apt/sources.list.d/php.list
apt-get -y update

# Instalar paquetes
apt-get -y install libapache2-mod-php8.0
apt-get -y install php8.0-cli
apt-get -y install php8.0-common
apt-get -y install php8.0-curl
apt-get -y install php8.0-dev
apt-get -y install php8.0-gd
apt-get -y install php8.0-imagick
apt-get -y install php8.0-intl
apt-get -y install php8.0-json
apt-get -y install php8.0-mbstring
apt-get -y install php8.0-mcrypt
apt-get -y install php8.0-mysql
apt-get -y install php8.0-pear
apt-get -y install php8.0-redis
apt-get -y install php8.0-xml
phpenmod curl
phpenmod gd
phpenmod intl
phpenmod imagick
phpenmod json          # Aparentemente no existe en la 8.0
phpenmod mbstring
phpenmod redis
phpenmod mcrypt        # Aparentemente no existe en la 8.0
cp /etc/php/8.0/apache2/php.ini /etc/php/8.0/apache2/php.ini.bak
sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g' /etc/php/8.0/apache2/php.ini
sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g' /etc/php/8.0/apache2/php.ini
sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php/8.0/apache2/php.ini
sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/8.0/apache2/php.ini

