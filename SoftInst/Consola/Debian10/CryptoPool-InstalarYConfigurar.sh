#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de criptomonedas en Debian10
#-------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo ""
echo -e "${ColorVerde}---------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación del pool de criptominería...${FinColor}"
echo -e "${ColorVerde}---------------------------------------------------------------${FinColor}"
echo ""
echo ""

## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "curl no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
fi

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "dialog no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install dialog
fi


## Instalar paquetes necesarios
   apt-get -y update
   apt-get -y install build-essential libcurl4-openssl-dev libdb5.3-dev libdb5.3++-dev mariadb-server

## Instalar servidor Web
   tasksel install web-server

## MPOS
   apt-get -y install memcached zip
   apt-get -y install php-dom php-mbstring php-memcached php-zip
   apt-get -y install libapache2-mod-php7.3
   apt-get -y install php7.3-curl php7.3-mysqlnd php7.3-json php7.3-xml 
   apache2ctl -k stop
   cd /var/www/
   ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "git no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update
        apt-get -y install git
      fi
   git clone git://github.com/MPOS/php-mpos.git MPOS
   cd MPOS
   git checkout master
   php composer.phar install
   
   echo "<VirtualHost *:80>"                                  > /etc/apache2/sites-available/pool.conf
   echo ""                                                   >> /etc/apache2/sites-available/pool.conf
   echo "  #Redirect permanent / https://pool.sitioweb.com/" >> /etc/apache2/sites-available/pool.conf
   echo ""                                                   >> /etc/apache2/sites-available/pool.conf
   echo "  ServerName pool.sitioweb.com"                     >> /etc/apache2/sites-available/pool.conf
   echo "  DocumentRoot /var/www/MPOS/public"                >> /etc/apache2/sites-available/pool.conf
   echo ""                                                   >> /etc/apache2/sites-available/pool.conf
   echo '  <Directory "/var/www/MPOS/public">'               >> /etc/apache2/sites-available/pool.conf
   echo "    Require all granted"                            >> /etc/apache2/sites-available/pool.conf
   echo "    Options FollowSymLinks"                         >> /etc/apache2/sites-available/pool.conf
   echo "    AllowOverride All"                              >> /etc/apache2/sites-available/pool.conf
   echo "  </Directory>"                                     >> /etc/apache2/sites-available/pool.conf
   echo ""                                                   >> /etc/apache2/sites-available/pool.conf
   echo "  ServerAdmin mail@gmail.com"                       >> /etc/apache2/sites-available/pool.conf
   echo ""                                                   >> /etc/apache2/sites-available/pool.conf
   echo "  ErrorLog  /var/www/MPOS/logs/error.log"           >> /etc/apache2/sites-available/pool.conf
   echo "  CustomLog /var/www/MPOS/logs/access.log combined" >> /etc/apache2/sites-available/pool.conf
   echo ""                                                   >> /etc/apache2/sites-available/pool.conf
   echo "</VirtualHost>"                                     >> /etc/apache2/sites-available/pool.conf
   touch /var/www/MPOS/logs/error.log
   touch /var/www/MPOS/logs/access.log
   apache2ctl -k start

## Litecoin
   cd ~
   git clone git://github.com/litecoin-project/litecoin.git
   cd litecoin
   apt-get -y install autoconf
   ./autogen.sh
   ./configure --with-incompatible-bdb
   make
   make check
   make install

