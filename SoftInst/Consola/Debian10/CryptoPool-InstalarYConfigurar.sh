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

VersPHP="7.3"
ContraRootMySQL=root
ContraBD="mpos"

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

## Servidor Stratum
   


## Instalar servidor Web
   tasksel install web-server

## MPOS
   apt-get -y install memcached zip
   apt-get -y install php-dom php-mbstring php-memcached php-zip
   apt-get -y install libapache2-mod-php$VersPHP
   apt-get -y install php$VersPHP-curl php$VersPHP-mysqlnd php$VersPHP-json php$VersPHP-xml 
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
   
   # Permisos
   chown -Rv www-data /var/www/MPOS/templates/compile
   chown -Rv www-data /var/www/MPOS/templates/cache
   chown -Rv www-data /var/www/MPOS/logs
   
   # Archivo de configuración
   cp /var/www/MPOS/include/config/global.inc.dist.php /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['db']['host'] = 'localhost';|$config['db']['host'] = 'localhost';|g'                                     /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['db']['user'] = 'root';|$config['db']['user'] = 'root';|g'                                               /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['db']['pass'] = 'root';|$config['db']['pass'] = 'root';|g'                                               /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['db']['port'] = 3306;|$config['db']['port'] = 3306;|g'                                                   /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['db']['name'] = 'mpos';|$config['db']['name'] = 'mpos';|g'                                               /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['wallet']['type'] = 'http';|$config['wallet']['type'] = 'http';|g'                                       /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['wallet']['host'] = 'localhost:19334';|$config['wallet']['host'] = 'localhost:19334';|g'                 /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['wallet']['username'] = 'testnet';|$config['wallet']['username'] = 'testnet';|g'                         /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['wallet']['password'] = 'testnet';|$config['wallet']['password'] = 'testnet';|g'                         /var/www/MPOS/include/config/global.inc.php
   sed -i -e 's|$config['gettingstarted']['stratumurl'] = 'localhost';|$config['gettingstarted']['stratumurl'] = 'localhost';|g' /var/www/MPOS/include/config/global.inc.php
   #sed -i -e 's|$config['SALT']||g'                                        /var/www/MPOS/include/config/global.inc.php
   #sed -i -e 's|$config['SALTY']||g'                                       /var/www/MPOS/include/config/global.inc.php
   #SALT and SALTY must be a minimum of 24 characters or you will get an error message:
   #'SALT or SALTY is too short, they should be more than 24 characters and changing them will require registering a
   
   # Servidor Stratum
   
   
   # Web socket
   sed -i -e 's|from autobahn.websocket import WebSocketServerProtocol, WebSocketServerFactory|from autobahn.twisted.websocket import WebSocketServerProtocol, WebSocketServerFactory|g' /usr/local/lib/python2.7/dist-packages/stratum-0.2.13-py2.7.egg/stratum/websocket_transport.py
   apache2ctl -k start

## Base de datos
   /root/scripts/d-scripts/MySQL-BaseDeDatos-Crear.sh mpos mpos $ContraBD
   # Borrar la base de datos anterior de mpos, si es que existe
   mysql -e "drop database if exists mpos"
   # Borrar el usuario mpos, si es que existe
   mysql -e "drop user if exists mpos@localhost"
   
   echo ""
   echo "Las bases de datos MySQL disponibles actualmente en el sistema son:"
   echo ""
   mysql -e "show databases"
   echo ""
   echo "Los usuarios MySQL disponibles actualmente en el sistema son:"
   echo ""
   mysql -e "select user,host from mysql.user"
   
   echo ""
   echo "Creando la base de datos mpos..."
   echo ""
   mysql -e "create database mpos"
   echo ""
   echo "Creando el usuario mpos@localhost..."
   echo ""
   mysql -e "create user mpos@localhost"
   echo ""
   echo "Dando permisos al usuario mpos para que administre la base de datos mpos..."
   echo ""
   mysql -e "grant all privileges on mpos.* to mpos@localhost identified by '$ContraBD'"
   
   echo ""
   echo "Las bases de datos MySQL disponibles actualmente en el sistema son:"
   echo ""
   mysql -e "show databases"
   echo ""
   echo "Los usuarios MySQL disponibles actualmente en el sistema son:"
   echo ""
   mysql -e "select user,host from mysql.user"
   
   
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

