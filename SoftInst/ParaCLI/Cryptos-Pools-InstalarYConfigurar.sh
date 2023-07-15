#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.


#  Script de NiPeGun para instalar y configurar Pools Cripto en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-Pools-InstalarYConfigurar.sh | bash


UsuarioNoRoot="pooladmin"
DominioPool="localhost"
VersPHP="7.3"
VersPostgre="11"

# Variables MiningCore
MiningCoreDBPass="12345678"
#MiningCoreDomain="http://localhost/"
#MiningCoreAPI="http://localhost/api/"
#MiningCoreStratum="stratum+tcp://localhost"
MiningCoreDomain="https://domain-name.com/"
MiningCoreAPI="https://domain-name.com/api/"
MiningCoreStratum="stratum+tcp://domain-name.com"

# Variables RVN
PuertoRPCrvn="20401"
UsuarioRPCrvn="rvnrpc"
PassRPCrvn="rvnrpcpass"

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Pools Cripto para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Pools Cripto para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Pools Cripto para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Pools Cripto para Debian 10 (Buster)..."
  
  echo ""

  ## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install dialog
       echo ""
     fi

  menu=(dialog --timeout 10 --checklist "Marca lo que quieras instalar:" 22 76 16)
    opciones=(1 "Instalar la pool rvn-kawpow-pool (Para Ravencoin)" off
              2 "Instalar la pool php-mpos" off
              3 "Instalar NodeJS" off
              4 "Instalar node-multi-hashing" off
              5 "Reparar permisos" off
              6 "Instalar servidor Web" off
              7 "Instalar MiningCore" off
              8 "Instalar MiningCore WebUI" off)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            echo ""
            echo -e "${cColorVerde}-----------------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando la pool rvn-kawpow-pool...${cFinColor}"
            echo -e "${cColorVerde}-----------------------------------------${cFinColor}"
            echo ""

            ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
               if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                 echo ""
                 echo "  git no está instalado. Iniciando su instalación..."
                 echo ""
                 apt-get -y update
                 apt-get -y install git
                 echo ""
               fi

            mkdir -p /root/SoftInst/ 2> /dev/null
            cd /root/SoftInst/
            git clone https://github.com/notminerproduction/rvn-kawpow-pool.git
            mv /root/SoftInst/rvn-kawpow-pool/ /root/
            find /root/rvn-kawpow-pool/ -type f -iname "*.sh" -exec chmod +x {} \;
            sed -i -e 's|"stratumHost": "192.168.0.200",|"stratumHost": "'"$DominioPool"'",|g'                                            /root/rvn-kawpow-pool/config.json
            sed -i -e 's|"address": "RKopFydExeQXSZZiSTtg66sRAWvMzFReUj",|"address": "'"$DirCartRVN"'",|g'                                /root/rvn-kawpow-pool/pool_configs/ravencoin.json
            sed -i -e 's|"donateaddress": "RKopFydExeQXSZZiSTtg66sRAWvMzFReUj",|"donateaddress": "RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy",|g' /root/rvn-kawpow-pool/pool_configs/ravencoin.json
            sed -i -e 's|RL5SUNMHmjXtN1AzCRFQrFEhjnf7QQY7Tz|RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy|g'                                         /root/rvn-kawpow-pool/pool_configs/ravencoin.json
            sed -i -e 's|Ta26x9axaDQWaV2bt2z8Dk3R3dN7gHw9b6|RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy|g'                                         /root/rvn-kawpow-pool/pool_configs/ravencoin.json
            apt-get -y install npm

            # Modificar el archivo de instalación
              find  /root/rvn-kawpow-pool/install.sh -type f -exec sed -i -e "s|sudo ||g" {} \;
              sed -i -e 's|apt upgrade -y|apt -y upgrade\napt install -y libssl-dev libboost-all-dev libminiupnpc-dev libtool autotools-dev redis-server|g'                                         /root/rvn-kawpow-pool/install.sh
              sed -i -e 's|add-apt-repository -y ppa:chris-lea/redis-server|#add-apt-repository -y ppa:chris-lea/redis-server|g'                                                                    /root/rvn-kawpow-pool/install.sh
              sed -i -e 's|add-apt-repository -y ppa:bitcoin/bitcoin|#add-apt-repository -y ppa:bitcoin/bitcoin|g'                                                                                  /root/rvn-kawpow-pool/install.sh
              sed -i -e 's|apt install -y libdb4.8-dev libdb4.8++-dev libssl-dev libboost-all-dev libminiupnpc-dev libtool autotools-dev redis-server|apt install -y libdb4.8-dev libdb4.8++-dev|g' /root/rvn-kawpow-pool/install.sh

            /root/rvn-kawpow-pool/install.sh
            find /root/rvn-kawpow-pool/pool-start.sh -type f -exec sed -i -e "s|sudo ||g" {} \;

          ;;

          2)
            echo ""
            echo -e "${cColorVerde}------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando la pool MPOS...${cFinColor}"
            echo -e "${cColorVerde}------------------------------${cFinColor}"
            echo ""

            ## Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
               if [[ $(dpkg-query -s tasksel 2>/dev/null | grep installed) == "" ]]; then
                 echo ""
                 echo "  tasksel no está instalado. Iniciando su instalación..."
                 echo ""
                 apt-get -y update
                 apt-get -y install tasksel
                 echo ""
               fi

            ## Instalar servidor Web
               tasksel install web-server

            ## Instalar paquetes necesarios
               apt-get -y update
               apt-get -y install build-essential libcurl4-openssl-dev libdb5.3-dev libdb5.3++-dev mariadb-server
               apt-get -y install memcached zip
               apt-get -y install php-dom php-mbstring php-memcached php-zip
               apt-get -y install libapache2-mod-php$VersPHP
               apt-get -y install php$VersPHP-curl php$VersPHP-mysqlnd php$VersPHP-json php$VersPHP-xml 

            apache2ctl -k stop
            cd /var/www/

            ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
               if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                 echo ""
                 echo "  git no está instalado. Iniciando su instalación..."
                 echo ""
                 apt-get -y update
                 apt-get -y install git
                 echo ""
               fi
            git clone git://github.com/MPOS/php-mpos.git MPOS
            cd MPOS
            git checkout master
            php composer.phar install
            ## Crear el sitio web en Apache
               echo "<VirtualHost *:80>"                                  > /etc/apache2/sites-available/pool.conf
               echo ""                                                   >> /etc/apache2/sites-available/pool.conf
               echo "  #Redirect permanent / https://$DominioPool/"      >> /etc/apache2/sites-available/pool.conf
               echo ""                                                   >> /etc/apache2/sites-available/pool.conf
               echo "  ServerName $DominioPool"                          >> /etc/apache2/sites-available/pool.conf
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
               a2ensite pool
               a2dissite 000-default
               a2dissite default-ssl
               service apache2 reload
               sleep 3
               service apache2 restart

            ## Permisos
               chown -Rv www-data /var/www/MPOS/templates/compile
               chown -Rv www-data /var/www/MPOS/templates/cache
               chown -Rv www-data /var/www/MPOS/logs

            ## Archivo de configuración
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
               sed -i -e 's|$config['gettingstarted']['stratumurl'] = '';|$config['gettingstarted']['stratumurl'] = 'localhost';|g'          /var/www/MPOS/include/config/global.inc.php
               sed -i -e 's|$config['check_valid_coinaddress'] = true;|$config['check_valid_coinaddress'] = false;|g'                        /var/www/MPOS/include/config/global.inc.php
               #sed -i -e 's|$config['SALT']||g'                                        /var/www/MPOS/include/config/global.inc.php
               #sed -i -e 's|$config['SALTY']||g'                                       /var/www/MPOS/include/config/global.inc.php
               #SALT and SALTY must be a minimum of 24 characters or you will get an error message:
               #'SALT or SALTY is too short, they should be more than 24 characters and changing them will require registering a

               ## Servidor Stratum

               ## Web socket
                  sed -i -e 's|from autobahn.websocket import WebSocketServerProtocol, WebSocketServerFactory|from autobahn.twisted.websocket import WebSocketServerProtocol, WebSocketServerFactory|g' /usr/local/lib/python2.7/dist-packages/stratum-0.2.13-py2.7.egg/stratum/websocket_transport.py
                  apache2ctl -k start

               ## Base de datos

                  ## Borrar la base de datos anterior de mpos, si es que existe
                     mysql -e "drop database if exists mpos"

                  ## Borrar el usuario mpos, si es que existe
                     mysql -e "drop user if exists mpos@localhost"

                  echo ""
                  echo "  Las bases de datos MySQL disponibles actualmente en el sistema son:"
                  echo ""
                  mysql -e "show databases"
                  echo ""
                  echo "  Los usuarios MySQL disponibles actualmente en el sistema son:"
                  echo ""
                  mysql -e "select user,host from mysql.user"

                  echo ""
                  echo "  Creando la base de datos mpos..."
                  echo ""
                  mysql -e "create database mpos"
                  echo ""
                  echo "  Creando el usuario mpos@localhost..."
                  echo ""
                  mysql -e "create user mpos@localhost"
                  echo ""
                  echo "  Dando permisos al usuario mpos para que administre la base de datos mpos..."
                  echo ""
                  mysql -e "grant all privileges on mpos.* to mpos@localhost identified by '$ContraBD'"

                  echo ""
                  echo "  Las bases de datos MySQL disponibles actualmente en el sistema son:"
                  echo ""
                  mysql -e "show databases"
                  echo ""
                  echo "  Los usuarios MySQL disponibles actualmente en el sistema son:"
                  echo ""
                  mysql -e "select user,host from mysql.user"

                  echo ""
                  echo "  Importando la estructura de la base de datos..."
                  echo ""
                  mysql -p mpos < /var/www/MPOS/sql/000_base_structure.sql

            ## Reparación de permisos
               chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

          ;;

          3)

            echo ""
            echo -e "${cColorVerde}------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando NodeJS...${cFinColor}"
            echo -e "${cColorVerde}------------------------${cFinColor}"
            echo ""

            apt-get -y update
            apt-get -y install nodejs npm

          ;;

          4)

            echo ""
            echo -e "${cColorVerde}------------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando node-multi-hashing...${cFinColor}"
            echo -e "${cColorVerde}------------------------------------${cFinColor}"
            echo ""

            npm install multi-hashing

          ;;

          5)

            echo ""
            echo -e "${cColorVerde}-------------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando kawpow-stratum-pool...${cFinColor}"
            echo -e "${cColorVerde}-------------------------------------${cFinColor}"
            echo ""

            cd /root/
            git clone https://github.com/RavenCommunity/kawpow-stratum-pool

          ;;

          5)

            echo ""
            echo -e "${cColorVerde}-------------------------${cFinColor}"
            echo -e "${cColorVerde}  Reparando permisos...${cFinColor}"
            echo -e "${cColorVerde}-------------------------${cFinColor}"
            echo ""

            chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/
            find /home/$UsuarioNoRoot/$CarpetaSoftLTC/bin/ -type f -exec chmod +x {} \;
            find /home/$UsuarioNoRoot/$CarpetaSoftRVN/bin/ -type f -exec chmod +x {} \;
            find /home/$UsuarioNoRoot/$CarpetaSoftARG/bin/ -type f -exec chmod +x {} \;
            find /home/$UsuarioNoRoot/$CarpetaSoftXMR/bin/ -type f -exec chmod +x {} \;
            find /home/$UsuarioNoRoot/ -type f -iname "*.sh" -exec chmod +x {} \;

            chown root:root /home/$UsuarioNoRoot/$CarpetaSoftXCH/bin/chrome-sandbox
            chmod 4755 /home/$UsuarioNoRoot/$CarpetaSoftXCH/bin/chrome-sandbox

          ;;

          6)

            echo ""
            echo -e "${cColorVerde}------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando servidor Web...${cFinColor}"
            echo -e "${cColorVerde}------------------------------${cFinColor}"
            echo ""

            ## Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
               if [[ $(dpkg-query -s tasksel 2>/dev/null | grep installed) == "" ]]; then
                 echo ""
                 echo "  tasksel no está instalado. Iniciando su instalación..."
                 echo ""
                 apt-get -y update
                 apt-get -y install tasksel
                 echo ""
               fi

            tasksel install web-server

          ;;

          7)

            echo ""
            echo -e "${cColorVerde}----------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando MiningCore...${cFinColor}"
            echo -e "${cColorVerde}----------------------------${cFinColor}"
            echo ""

            ## Instalar .NET Core 2.2 SDK para Linux (Necesario para correr el motor Stratum)
               mkdir -p /root/SoftInst/MS.NETCore/ 2> /dev/null
               cd /root/
               wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb -O /root/SoftInst/MS.NETCore/packages-microsoft-prod.deb
               dpkg -i /root/SoftInst/MS.NETCore/packages-microsoft-prod.deb
               apt-get -y update
               apt-get -y install apt-transport-https
               apt-get update
               apt-get -y install dotnet-sdk-2.2

            ## Instalar MiningCore
               apt-get -y install cmake build-essential libssl-dev pkg-config libboost-all-dev libsodium-dev libzmq5 libzmq3-dev
               cd /root/
               git clone https://github.com/coinfoundry/miningcore.git
               cd /root/miningcore/src/Miningcore/
               dotnet publish -c Release --framework netcoreapp2.2  -o ../../build

            ## Crear el archivo de configuración json de MiningCore
               echo '{'                                                                                                                                        > /root/miningcore/build/config.json
               echo '    "logging": {'                                                                                                                        >> /root/miningcore/build/config.json
               echo '        "level": "info",'                                                                                                                >> /root/miningcore/build/config.json
               echo '        "enableConsoleLog": true,'                                                                                                       >> /root/miningcore/build/config.json
               echo '        "enableConsoleColors": true,'                                                                                                    >> /root/miningcore/build/config.json
               echo '        // Log file name (full log) - can be null in which case log events are written to console (stdout)'                              >> /root/miningcore/build/config.json
               echo '        "logFile": "core.log",'                                                                                                          >> /root/miningcore/build/config.json
               echo '        // Log file name for API-requests - can be null in which case log events are written to either main logFile or console (stdout)' >> /root/miningcore/build/config.json
               echo '        "apiLogFile": "api.log",'                                                                                                        >> /root/miningcore/build/config.json
               echo '        // Folder to store log file(s)'                                                                                                  >> /root/miningcore/build/config.json
               echo '        "logBaseDirectory": "/path/to/logs", // or c:\path\to\logs on Windows'                                                           >> /root/miningcore/build/config.json
               echo '        // If enabled, separate log file will be stored for each pool as <pool id>.log'                                                  >> /root/miningcore/build/config.json
               echo '        // in the above specific folder.'                                                                                                >> /root/miningcore/build/config.json
               echo '        "perPoolLogFile": false'                                                                                                         >> /root/miningcore/build/config.json
               echo '    },'                                                                                                                                  >> /root/miningcore/build/config.json
               echo '    "banning": {'                                                                                                                        >> /root/miningcore/build/config.json
               echo '        // "integrated" or "iptables" (linux only - not yet implemented)'                                                                >> /root/miningcore/build/config.json
               echo '        "manager": "integrated",'                                                                                                        >> /root/miningcore/build/config.json
               echo '        "banOnJunkReceive": true,'                                                                                                       >> /root/miningcore/build/config.json
               echo '        "banOnInvalidShares": false'                                                                                                     >> /root/miningcore/build/config.json
               echo '    },'                                                                                                                                  >> /root/miningcore/build/config.json
               echo '    "notifications": {'                                                                                                                  >> /root/miningcore/build/config.json
               echo '        "enabled": true,'                                                                                                                >> /root/miningcore/build/config.json
               echo '        "email": {'                                                                                                                      >> /root/miningcore/build/config.json
               echo '            "host": "smtp.example.com",'                                                                                                 >> /root/miningcore/build/config.json
               echo '            "port": 587,'                                                                                                                >> /root/miningcore/build/config.json
               echo '            "user": "user",'                                                                                                             >> /root/miningcore/build/config.json
               echo '            "password": "password",'                                                                                                     >> /root/miningcore/build/config.json
               echo '            "fromAddress": "info@yourpool.org",'                                                                                         >> /root/miningcore/build/config.json
               echo '            "fromName": "pool support"'                                                                                                  >> /root/miningcore/build/config.json
               echo '        },'                                                                                                                              >> /root/miningcore/build/config.json
               echo '        "admin": '                                                                                                                       >> /root/miningcore/build/config.json
               echo '            "enabled": false,'                                                                                                           >> /root/miningcore/build/config.json
               echo '            "emailAddress": "user@example.com",'                                                                                         >> /root/miningcore/build/config.json
               echo '            "notifyBlockFound": true'                                                                                                    >> /root/miningcore/build/config.json
               echo '        }'                                                                                                                               >> /root/miningcore/build/config.json
               echo '    },'                                                                                                                                  >> /root/miningcore/build/config.json
               echo '    // Where to persist shares and blocks to'                                                                                            >> /root/miningcore/build/config.json
               echo '    "persistence": {'                                                                                                                    >> /root/miningcore/build/config.json
               echo '        // Persist to postgresql database'                                                                                               >> /root/miningcore/build/config.json
               echo '        "postgres": {'                                                                                                                   >> /root/miningcore/build/config.json
               echo '            "host": "127.0.0.1",'                                                                                                        >> /root/miningcore/build/config.json
               echo '            "port": 5432,'                                                                                                               >> /root/miningcore/build/config.json
               echo '            "user": "miningcore",'                                                                                                       >> /root/miningcore/build/config.json
               echo '            "password": "yourpassword",'                                                                                                 >> /root/miningcore/build/config.json
               echo '            "database": "miningcore"'                                                                                                    >> /root/miningcore/build/config.json
               echo '        }'                                                                                                                               >> /root/miningcore/build/config.json
               echo '    },'                                                                                                                                  >> /root/miningcore/build/config.json
               echo '    // Generate payouts for recorded shares and blocks'                                                                                  >> /root/miningcore/build/config.json
               echo '    "paymentProcessing": {'                                                                                                              >> /root/miningcore/build/config.json
               echo '        "enabled": true,'                                                                                                                >> /root/miningcore/build/config.json
               echo '        // How often to process payouts, in milliseconds'                                                                                >> /root/miningcore/build/config.json
               echo '        "interval": 600,'                                                                                                                >> /root/miningcore/build/config.json
               echo '        // Path to a file used to backup shares under emergency conditions, such as'                                                     >> /root/miningcore/build/config.json
               echo '        // database outage'                                                                                                              >> /root/miningcore/build/config.json
               echo '        "shareRecoveryFile": "recovered-shares.txt"'                                                                                     >> /root/miningcore/build/config.json
               echo '    },'                                                                                                                                  >> /root/miningcore/build/config.json
               echo '    // API Settings'                                                                                                                     >> /root/miningcore/build/config.json
               echo '    "api": {'                                                                                                                            >> /root/miningcore/build/config.json
               echo '        "enabled": true,'                                                                                                                >> /root/miningcore/build/config.json
               echo '        // Binding address (Default: 127.0.0.1)'                                                                                         >> /root/miningcore/build/config.json
               echo '        "listenAddress": "127.0.0.1",'                                                                                                   >> /root/miningcore/build/config.json
               echo '        // Binding port (Default: 4000)'                                                                                                 >> /root/miningcore/build/config.json
               echo '        "port": 4000,'                                                                                                                   >> /root/miningcore/build/config.json
               echo '        // IP address whitelist for requests to Prometheus Metrics (default 127.0.0.1)'                                                  >> /root/miningcore/build/config.json
               echo '        "metricsIpWhitelist": [],'                                                                                                       >> /root/miningcore/build/config.json
               echo '        // Limit rate of requests to API on a per-IP basis'                                                                              >> /root/miningcore/build/config.json
               echo '        "rateLimiting": {'                                                                                                               >> /root/miningcore/build/config.json
               echo '            "disabled": false, // disable rate-limiting all-together, be careful'                                                        >> /root/miningcore/build/config.json
               echo '            // override default rate-limit rules, refer to https://github.com/stefanprodan/AspNetCoreRateLimit/wiki/IpRateLimitMiddleware#defining-rate-limit-rules' >> /root/miningcore/build/config.json
               echo '            "rules": ['                                                                                                                  >> /root/miningcore/build/config.json
               echo '                {'                                                                                                                       >> /root/miningcore/build/config.json
               echo '                    "Endpoint": "*",'                                                                                                    >> /root/miningcore/build/config.json
               echo '                    "Period": "1s",'                                                                                                     >> /root/miningcore/build/config.json
               echo '                    "Limit": 5'                                                                                                          >> /root/miningcore/build/config.json
               echo '                }'                                                                                                                       >> /root/miningcore/build/config.json
               echo '            ],'                                                                                                                          >> /root/miningcore/build/config.json
               echo '            // List of IP addresses excempt from rate-limiting (default: none)'                                                          >> /root/miningcore/build/config.json
               echo '            "ipWhitelist": []'                                                                                                           >> /root/miningcore/build/config.json
               echo '        }'                                                                                                                               >> /root/miningcore/build/config.json
               echo '    },'                                                                                                                                  >> /root/miningcore/build/config.json
               echo '    "pools": ['                                                                                                                          >> /root/miningcore/build/config.json
               echo '        {'                                                                                                                               >> /root/miningcore/build/config.json
               echo '            // DONT change the id after a production pool has begun collecting shares!'                                                  >> /root/miningcore/build/config.json
               echo '            "id": "dash1",'                                                                                                              >> /root/miningcore/build/config.json
               echo '            "enabled": true,'                                                                                                            >> /root/miningcore/build/config.json
               echo '            "coin": "dash",'                                                                                                             >> /root/miningcore/build/config.json
               echo '            // Address to where block rewards are given (pool wallet)'                                                                   >> /root/miningcore/build/config.json
               echo '            "address": "yiZodEgQLbYDrWzgBXmfUUHeBVXBNr8rwR",'                                                                            >> /root/miningcore/build/config.json
               echo '            // Block rewards go to the configured pool wallet address to later be paid out'                                              >> /root/miningcore/build/config.json
               echo '            // to miners, except for a percentage that can go to, for examples,'                                                         >> /root/miningcore/build/config.json
               echo '            // pool operator(s) as pool fees or or to donations address. Addresses or hashed'                                            >> /root/miningcore/build/config.json
               echo '            // public keys can be used. Here is an example of rewards going to the main pool'                                            >> /root/miningcore/build/config.json
               echo '            // "op"'                                                                                                                     >> /root/miningcore/build/config.json
               echo '            "rewardRecipients": ['                                                                                                       >> /root/miningcore/build/config.json
               echo '                {'                                                                                                                       >> /root/miningcore/build/config.json
               echo '                    // Pool wallet'                                                                                                      >> /root/miningcore/build/config.json
               echo '                    "address": "yiZodEgQLbYDrWzgBXmfUUHeBVXBNr8rwR",'                                                                    >> /root/miningcore/build/config.json
               echo '                    "percentage": 1.5'                                                                                                   >> /root/miningcore/build/config.json
               echo '                }'                                                                                                                       >> /root/miningcore/build/config.json
               echo '            ],'                                                                                                                          >> /root/miningcore/build/config.json
               echo '            // How often to poll RPC daemons for new blocks, in milliseconds'                                                            >> /root/miningcore/build/config.json
               echo '            "blockRefreshInterval": 400,'                                                                                                >> /root/miningcore/build/config.json
               echo '            // Some miner apps will consider the pool dead/offline if it doesnt receive'                                                 >> /root/miningcore/build/config.json
               echo '            // anything new jobs for around a minute, so every time we broadcast jobs,'                                                  >> /root/miningcore/build/config.json
               echo '            // set a timeout to rebroadcast in this many seconds unless we find a new job.'                                              >> /root/miningcore/build/config.json
               echo '            // Set to zero to disable. (Default: 0)'                                                                                     >> /root/miningcore/build/config.json
               echo '            "jobRebroadcastTimeout": 10,'                                                                                                >> /root/miningcore/build/config.json
               echo '            // Remove workers that havent been in contact for this many seconds.'                                                        >> /root/miningcore/build/config.json
               echo '            // Some attackers will create thousands of workers that use up all available'                                                >> /root/miningcore/build/config.json
               echo '            // socket connections, usually the workers are zombies and dont submit shares'                                               >> /root/miningcore/build/config.json
               echo '            // after connecting. This features detects those and disconnects them.'                                                      >> /root/miningcore/build/config.json
               echo '            "clientConnectionTimeout": 600,'                                                                                             >> /root/miningcore/build/config.json
               echo '            // If a worker is submitting a high threshold of invalid shares, we can'                                                     >> /root/miningcore/build/config.json
               echo '            // temporarily ban their IP to reduce system/network load.'                                                                  >> /root/miningcore/build/config.json
               echo '            "banning": {'                                                                                                                >> /root/miningcore/build/config.json
               echo '                "enabled": true,'                                                                                                        >> /root/miningcore/build/config.json
               echo '                // How many seconds to ban worker for'                                                                                   >> /root/miningcore/build/config.json
               echo '                "time": 600,'                                                                                                            >> /root/miningcore/build/config.json
               echo '                // What percent of invalid shares triggers ban'                                                                          >> /root/miningcore/build/config.json
               echo '                "invalidPercent": 50,'                                                                                                   >> /root/miningcore/build/config.json
               echo '                // Check invalid percent when this many shares have been submitted'                                                      >> /root/miningcore/build/config.json
               echo '                "checkThreshold": 50'                                                                                                    >> /root/miningcore/build/config.json
               echo '            },'                                                                                                                          >> /root/miningcore/build/config.json
               echo '            // Each pool can have as many ports for your miners to connect to as you wish.'                                              >> /root/miningcore/build/config.json
               echo '            // Each port can be configured to use its own pool difficulty and variable'                                                  >> /root/miningcore/build/config.json
               echo '            // difficulty settings. "varDiff" is optional and will only be used for the ports'                                           >> /root/miningcore/build/config.json
               echo '            // you configure it for.'                                                                                                    >> /root/miningcore/build/config.json
               echo '            "ports": {'                                                                                                                  >> /root/miningcore/build/config.json
               echo '                // Binding port for your miners to connect to'                                                                           >> /root/miningcore/build/config.json
               echo '                "3052": {'                                                                                                               >> /root/miningcore/build/config.json
               echo '                    // Binding address (Default: 127.0.0.1)'                                                                             >> /root/miningcore/build/config.json
               echo '                    "listenAddress": "0.0.0.0",'                                                                                         >> /root/miningcore/build/config.json
               echo '                    // Pool difficulty'                                                                                                  >> /root/miningcore/build/config.json
               echo '                    "difficulty": 0.02,'                                                                                                 >> /root/miningcore/build/config.json
               echo '                    // TLS/SSL configuration'                                                                                            >> /root/miningcore/build/config.json
               echo '                    "tls": false,'                                                                                                       >> /root/miningcore/build/config.json
               echo '                    "tlsPfxFile": "/var/lib/certs/mycert.pfx",'                                                                          >> /root/miningcore/build/config.json
               echo '                    // Variable difficulty is a feature that will automatically adjust difficulty'                                       >> /root/miningcore/build/config.json
               echo '                    // for individual miners based on their hash rate in order to lower'                                                 >> /root/miningcore/build/config.json
               echo '                    // networking overhead'                                                                                              >> /root/miningcore/build/config.json
               echo '                    "varDiff": {'                                                                                                        >> /root/miningcore/build/config.json
               echo '                        // Minimum difficulty'                                                                                           >> /root/miningcore/build/config.json
               echo '                        "minDiff": 0.01,'                                                                                                >> /root/miningcore/build/config.json
               echo '                        // Maximum difficulty. Network difficulty will be used if it is lower than'                                      >> /root/miningcore/build/config.json
               echo '                        // this. Set to null to disable.'                                                                                >> /root/miningcore/build/config.json
               echo '                        "maxDiff": null,'                                                                                                >> /root/miningcore/build/config.json
               echo '                        // Try to get 1 share per this many seconds'                                                                     >> /root/miningcore/build/config.json
               echo '                        "targetTime": 15,'                                                                                               >> /root/miningcore/build/config.json
               echo '                        // Check to see if we should retarget every this many seconds'                                                   >> /root/miningcore/build/config.json
               echo '                        "retargetTime": 90,'                                                                                             >> /root/miningcore/build/config.json
               echo '                        // Allow time to very this % from target without retargeting'                                                    >> /root/miningcore/build/config.json
               echo '                        "variancePercent": 30,'                                                                                          >> /root/miningcore/build/config.json
               echo '                        // Do not alter difficulty by more than this during a single retarget in'                                        >> /root/miningcore/build/config.json
               echo '                        // either direction'                                                                                             >> /root/miningcore/build/config.json
               echo '                        "maxDelta": 500'                                                                                                 >> /root/miningcore/build/config.json
               echo '                    }'                                                                                                                   >> /root/miningcore/build/config.json
               echo '                }'                                                                                                                       >> /root/miningcore/build/config.json
               echo '            },'                                                                                                                          >> /root/miningcore/build/config.json
               echo '            // Recommended to have at least two daemon instances running in case one drops'                                              >> /root/miningcore/build/config.json
               echo '            // out-of-sync or offline. For redundancy, all instances will be polled for'                                                 >> /root/miningcore/build/config.json
               echo '            // block/transaction updates and be used for submitting blocks. Creating a backup'                                           >> /root/miningcore/build/config.json
               echo '            // daemon involves spawning a daemon using the "-datadir=/backup" argument which'                                            >> /root/miningcore/build/config.json
               echo '            // creates a new daemon instance with its own RPC config. For more info on this,'                                            >> /root/miningcore/build/config.json
               echo '            // visit: https:// en.bitcoin.it/wiki/Data_directory and'                                                                    >> /root/miningcore/build/config.json
               echo '            // https:// en.bitcoin.it/wiki/Running_bitcoind'                                                                             >> /root/miningcore/build/config.json
               echo '            "daemons": ['                                                                                                                >> /root/miningcore/build/config.json
               echo '                {'                                                                                                                       >> /root/miningcore/build/config.json
               echo '                    "host": "127.0.0.1",'                                                                                                >> /root/miningcore/build/config.json
               echo '                    "port": 15001,'                                                                                                      >> /root/miningcore/build/config.json
               echo '                    "user": "user",'                                                                                                     >> /root/miningcore/build/config.json
               echo '                    "password": "pass",'                                                                                                 >> /root/miningcore/build/config.json
               echo '                    // Enable streaming Block Notifications via ZeroMQ messaging from Bitcoin'                                           >> /root/miningcore/build/config.json
               echo '                    // Family daemons. Using this is highly recommended. The value of this option'                                       >> /root/miningcore/build/config.json
               echo '                    // is a string that should match the value of the -zmqpubhashblock parameter'                                        >> /root/miningcore/build/config.json
               echo '                    // passed to the coin daemon. If you enable this, you should lower'                                                  >> /root/miningcore/build/config.json
               echo '                    // "blockRefreshInterval" to 1000 or 0 to disable polling entirely.'                                                 >> /root/miningcore/build/config.json
               echo '                    "zmqBlockNotifySocket": "tcp://127.0.0.1:15101",'                                                                    >> /root/miningcore/build/config.json
               echo '                    // Enable streaming Block Notifications via WebSocket messaging from Ethereum'                                       >> /root/miningcore/build/config.json
               echo '                    // family Parity daemons. Using this is highly recommended. The value of this'                                       >> /root/miningcore/build/config.json
               echo '                    // option is a string that should  match the value of the --ws-port parameter'                                       >> /root/miningcore/build/config.json
               echo '                    // passed to the parity coin daemon. When using --ws-port, you should also'                                          >> /root/miningcore/build/config.json
               echo '                    // specify --ws-interface all and'                                                                                   >> /root/miningcore/build/config.json
               echo '                    // --jsonrpc-apis "eth,net,web3,personal,parity,parity_pubsub,rpc"'                                                  >> /root/miningcore/build/config.json
               echo '                    // If you enable this, you should lower "blockRefreshInterval" to 1000 or 0'                                         >> /root/miningcore/build/config.json
               echo '                    // to disable polling entirely.'                                                                                     >> /root/miningcore/build/config.json
               echo '                    "portWs": 18545,'                                                                                                    >> /root/miningcore/build/config.json
               echo '                }'                                                                                                                       >> /root/miningcore/build/config.json
               echo '            ],'                                                                                                                          >> /root/miningcore/build/config.json
               echo '            // Generate payouts for recorded shares'                                                                                     >> /root/miningcore/build/config.json
               echo '            "paymentProcessing": {'                                                                                                      >> /root/miningcore/build/config.json
               echo '                "enabled": true,'                                                                                                        >> /root/miningcore/build/config.json
               echo '                // Minimum payment in pool-base-currency (ie. Bitcoin, NOT Satoshis)'                                                    >> /root/miningcore/build/config.json
               echo '                "minimumPayment": 0.01,'                                                                                                 >> /root/miningcore/build/config.json
               echo '                "payoutScheme": "PPLNS",'                                                                                                >> /root/miningcore/build/config.json
               echo '                "payoutSchemeConfig": {'                                                                                                 >> /root/miningcore/build/config.json
               echo '                    "factor": 2.0'                                                                                                       >> /root/miningcore/build/config.json
               echo '                }'                                                                                                                       >> /root/miningcore/build/config.json
               echo '            }'                                                                                                                           >> /root/miningcore/build/config.json
               echo '        }'                                                                                                                               >> /root/miningcore/build/config.json
               echo '    ]'                                                                                                                                   >> /root/miningcore/build/config.json
               echo '}'                                                                                                                                       >> /root/miningcore/build/config.json

               echo '{'                                                          > /root/miningcore/build/config-rvn.json
               echo '  "logging":{'                                             >> /root/miningcore/build/config-rvn.json
               echo '    "level":"info",'                                       >> /root/miningcore/build/config-rvn.json
               echo '    "enableConsoleLog":true,'                              >> /root/miningcore/build/config-rvn.json
               echo '    "enableConsoleColors":true,'                           >> /root/miningcore/build/config-rvn.json
               echo '    "logFile":"pool.log",'                                 >> /root/miningcore/build/config-rvn.json
               echo '    "apiLogFile":"poolapi.log",'                           >> /root/miningcore/build/config-rvn.json
               echo '    "logBaseDirectory":"/var/log/miningcore",'             >> /root/miningcore/build/config-rvn.json
               echo '    "perPoolLogFile":false'                                >> /root/miningcore/build/config-rvn.json
               echo '  },'                                                      >> /root/miningcore/build/config-rvn.json
               echo '  "banning":{'                                             >> /root/miningcore/build/config-rvn.json
               echo '    "manager":"integrated",'                               >> /root/miningcore/build/config-rvn.json
               echo '    "banOnJunkReceive":true,'                              >> /root/miningcore/build/config-rvn.json
               echo '    "banOnInvalidShares":false'                            >> /root/miningcore/build/config-rvn.json
               echo '  },'                                                      >> /root/miningcore/build/config-rvn.json
               echo '  "notifications":{'                                       >> /root/miningcore/build/config-rvn.json
               echo '    "enabled":false,'                                      >> /root/miningcore/build/config-rvn.json
               echo '    "email":{'                                             >> /root/miningcore/build/config-rvn.json
               echo '      "host":"smtp.example.com",'                          >> /root/miningcore/build/config-rvn.json
               echo '      "port":587,'                                         >> /root/miningcore/build/config-rvn.json
               echo '      "user":"user",'                                      >> /root/miningcore/build/config-rvn.json
               echo '      "password":"password",'                              >> /root/miningcore/build/config-rvn.json
               echo '      "fromAddress":"info@yourpool.org",'                  >> /root/miningcore/build/config-rvn.json
               echo '      "fromName":"support"'                                >> /root/miningcore/build/config-rvn.json
               echo '    },'                                                    >> /root/miningcore/build/config-rvn.json
               echo '    "admin":{'                                             >> /root/miningcore/build/config-rvn.json
               echo '      "enabled":false,'                                    >> /root/miningcore/build/config-rvn.json
               echo '      "emailAddress":"user@example.com",'                  >> /root/miningcore/build/config-rvn.json
               echo '      "notifyBlockFound":true'                             >> /root/miningcore/build/config-rvn.json
               echo '    }'                                                     >> /root/miningcore/build/config-rvn.json
               echo '  },'                                                      >> /root/miningcore/build/config-rvn.json
               echo '  "persistence":{'                                         >> /root/miningcore/build/config-rvn.json
               echo '    "postgres":{'                                          >> /root/miningcore/build/config-rvn.json
               echo '      "host":"127.0.0.1",'                                 >> /root/miningcore/build/config-rvn.json
               echo '      "port":5432,'                                        >> /root/miningcore/build/config-rvn.json
               echo '      "user":"'"$UsuarioNoRoot"'",'                        >> /root/miningcore/build/config-rvn.json
               echo '      "password":"'"$MiningCoreDBPass"'",'                 >> /root/miningcore/build/config-rvn.json
               echo '      "database":"miningcore"'                             >> /root/miningcore/build/config-rvn.json
               echo '    }'                                                     >> /root/miningcore/build/config-rvn.json
               echo '  },'                                                      >> /root/miningcore/build/config-rvn.json
               echo '  "paymentProcessing":{'                                   >> /root/miningcore/build/config-rvn.json
               echo '    "enabled":false,'                                      >> /root/miningcore/build/config-rvn.json
               echo '    "interval":600,'                                       >> /root/miningcore/build/config-rvn.json
               echo '    "shareRecoveryFile":"recovered-shares.txt"'            >> /root/miningcore/build/config-rvn.json
               echo '  },'                                                      >> /root/miningcore/build/config-rvn.json
               echo '  "api":{'                                                 >> /root/miningcore/build/config-rvn.json
               echo '    "enabled":false,'                                      >> /root/miningcore/build/config-rvn.json
               echo '    "listenAddress":"0.0.0.0",'                            >> /root/miningcore/build/config-rvn.json
               echo '    "port":4000,'                                          >> /root/miningcore/build/config-rvn.json
               echo '    "adminPort":4010'                                      >> /root/miningcore/build/config-rvn.json
               echo '  },'                                                      >> /root/miningcore/build/config-rvn.json
               echo '  "pools":['                                               >> /root/miningcore/build/config-rvn.json
               echo '    {'                                                     >> /root/miningcore/build/config-rvn.json
               echo '      "id":"RVN",'                                         >> /root/miningcore/build/config-rvn.json
               echo '      "enabled":true,'                                     >> /root/miningcore/build/config-rvn.json
               echo '      "coin":"ravencoin",'                                 >> /root/miningcore/build/config-rvn.json
               echo '      "address":"DirCarteraPoolRVN",'                      >> /root/miningcore/build/config-rvn.json
               echo '      "rewardRecipients":['                                >> /root/miningcore/build/config-rvn.json
               echo '        {'                                                 >> /root/miningcore/build/config-rvn.json
               echo '          "address":"RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy",' >> /root/miningcore/build/config-rvn.json
               echo '          "percentage":5'                                  >> /root/miningcore/build/config-rvn.json
               echo '        }'                                                 >> /root/miningcore/build/config-rvn.json
               echo '      ],'                                                  >> /root/miningcore/build/config-rvn.json
               echo '      "blockRefreshInterval":1000,'                        >> /root/miningcore/build/config-rvn.json
               echo '      "jobRebroadcastTimeout":10,'                         >> /root/miningcore/build/config-rvn.json
               echo '      "clientConnectionTimeout":600,'                      >> /root/miningcore/build/config-rvn.json
               echo '      "banning":{'                                         >> /root/miningcore/build/config-rvn.json
               echo '        "enabled":false,'                                  >> /root/miningcore/build/config-rvn.json
               echo '        "time":600,'                                       >> /root/miningcore/build/config-rvn.json
               echo '        "invalidPercent":50,'                              >> /root/miningcore/build/config-rvn.json
               echo '        "checkThreshold":50'                               >> /root/miningcore/build/config-rvn.json
               echo '      },'                                                  >> /root/miningcore/build/config-rvn.json
               echo '      "ports":{'                                           >> /root/miningcore/build/config-rvn.json
               echo '        "42061":{'                                         >> /root/miningcore/build/config-rvn.json
               echo '          "listenAddress":"127.0.0.1",'                    >> /root/miningcore/build/config-rvn.json
               echo '          "difficulty":16,'                                >> /root/miningcore/build/config-rvn.json
               echo '          "name":"Solo Mining",'                           >> /root/miningcore/build/config-rvn.json
               echo '          "varDiff":{'                                     >> /root/miningcore/build/config-rvn.json
               echo '            "minDiff":1,'                                  >> /root/miningcore/build/config-rvn.json
               echo '            "targetTime":15,'                              >> /root/miningcore/build/config-rvn.json
               echo '            "retargetTime":90,'                            >> /root/miningcore/build/config-rvn.json
               echo '            "variancePercent":30'                          >> /root/miningcore/build/config-rvn.json
               echo '          }'                                               >> /root/miningcore/build/config-rvn.json
               echo '        }'                                                 >> /root/miningcore/build/config-rvn.json
               echo '      },'                                                  >> /root/miningcore/build/config-rvn.json
               echo '      "daemons":['                                         >> /root/miningcore/build/config-rvn.json
               echo '        {'                                                 >> /root/miningcore/build/config-rvn.json
               echo '          "host":"127.0.0.1",'                             >> /root/miningcore/build/config-rvn.json
               echo '          "port":"'"$PuertoRPCrvn"'",'                     >> /root/miningcore/build/config-rvn.json
               echo '          "user":"'"$UsuarioRPCrvn"'",'                    >> /root/miningcore/build/config-rvn.json
               echo '          "password":"'"$PassRPCrvn"'",'                   >> /root/miningcore/build/config-rvn.json
               echo '          "zmqBlockNotifySocket":"tcp://127.0.0.1:8767"'   >> /root/miningcore/build/config-rvn.json
               echo '        }'                                                 >> /root/miningcore/build/config-rvn.json
               echo '      ],'                                                  >> /root/miningcore/build/config-rvn.json
               echo '      "paymentProcessing":{'                               >> /root/miningcore/build/config-rvn.json
               echo '        "enabled":true,'                                   >> /root/miningcore/build/config-rvn.json
               echo '        "minimumPayment":5,'                               >> /root/miningcore/build/config-rvn.json
               echo '        "payoutScheme":"PPLNS",'                           >> /root/miningcore/build/config-rvn.json
               echo '        "payoutSchemeConfig":{'                            >> /root/miningcore/build/config-rvn.json
               echo '          "factor":2.0'                                    >> /root/miningcore/build/config-rvn.json
               echo '        }'                                                 >> /root/miningcore/build/config-rvn.json
               echo '      }'                                                   >> /root/miningcore/build/config-rvn.json
               echo '    }'                                                     >> /root/miningcore/build/config-rvn.json
               echo '  ]'                                                       >> /root/miningcore/build/config-rvn.json
               echo '}'                                                         >> /root/miningcore/build/config-rvn.json

            ## Asignar dirección de cartera al archivo de configuración
               DirCartRVNtxt=$(cat /home/pooladmin/pooladdress-rvn.txt)
               sed -i -e 's|DirCarteraPoolRVN|'$DirCartRVNtxt'|g' /root/miningcore/build/config-rvn.json

            ## Instalar base de datos PostgreSQL
               apt-get -y install postgresql

            ## Crear la base de datos PostgreSQL

               ## Crear rol para la base de datos
                  echo ""
                  echo "  Creando el rol $UsuarioNoRoot..."
                  echo ""
                  su - postgres -c "createuser --interactive --pwprompt $UsuarioNoRoot"

               ## Crear la base de datos con el rol recién creado
                  echo ""
                  echo "  Creando la base de datos miningcore para el rol $UsuarioNoRoot..."
                  echo ""
                  su - postgres -c "createdb -O $UsuarioNoRoot miningcore"

               ## Si se quiere que el propietario de la base de datos sea postgres y no el rol de arriba
                  #su - postgres -c "createuser miningcore -d -P"
                  #su - postgres -c "createdb miningcore"
                  #su - postgres -c "psql"
                    #alter user miningcore with encrypted password '12345678';
                    #grant all privileges on database miningcore to miningcore;

               ## Cambiar la autentificación a MD5
                  sed -i -e 's|local   all             all                                     peer|local   all             all                                     md5|g' /etc/postgresql/$VersPostgre/main/pg_hba.conf

               ## Reiniciar PostgreSQL
                  service postgresql restart

               ## Importar el formato básico de la base de datos
                  echo ""
                  echo "  Importando la estructura de la base de datos..."
                  echo ""
                  rm /tmp/miningcore-basic.sql
                  su - postgres -c "wget https://raw.githubusercontent.com/coinfoundry/miningcore/master/src/Miningcore/Persistence/Postgres/Scripts/createdb.sql -O /tmp/miningcore-basic.sql"
                  chmod 777 /tmp/miningcore-basic.sql
                  sed -i -e 's|SET ROLE miningcore;|SET ROLE '$UsuarioNoRoot';|g' /tmp/miningcore-basic.sql
                  echo ""
                  echo "  Ingresa la contraseña del rol $UsuarioNoRoot:"
                  echo ""
                  su - postgres -c "psql -d miningcore -U $UsuarioNoRoot -f /tmp/miningcore-basic.sql -W"

               ## Mejorar a formato multi-pool
                  #su - postgres -c "wget https://raw.githubusercontent.com/coinfoundry/miningcore/master/src/Miningcore/Persistence/Postgres/Scripts/createdb_postgresql_11_appendix.sql -O /tmp/miningcore-advanced.sql"
                  #su - postgres -c "psql -d miningcore -U miningcore -f /tmp/miningcore-advanced.sql -W"
            echo ""
            echo "  Instalación de MiningCore finalizada."
            echo ""
            echo "  Para ver si la base de datos fue creada correctamente, ejecuta:"
            echo ""
            echo 'su - postgres -c "psql -h localhost --username=miningcore --list"'

            ## Ejecutar MiningCore
               cd /root/miningcore/build/
               dotnet Miningcore.dll -c /root/miningcore/build/config-rvn.json

          ;;

          8)

            echo ""
            echo -e "${cColorVerde}----------------------------------${cFinColor}"
            echo -e "${cColorVerde}  Instalando MiningCore WebUI...${cFinColor}"
            echo -e "${cColorVerde}----------------------------------${cFinColor}"
            echo ""

            ## Descargar MiningCore.WebUI
               cd /root
               rm -rf /root/Miningcore.WebUI/
               git clone https://github.com/minernl/Miningcore.WebUI
               rm -rf /root/Miningcore.WebUI/.git/
               rm -rf /root/Miningcore.WebUI/README.md

            ## Modificar las carpetas por defecto
               sed -i -e 's|window.location.protocol + "//" + window.location.hostname + "/";|"'$MiningCoreDomain'";|g'                /root/Miningcore.WebUI/js/miningcore.js
               sed -i -e 's|WebURL + "api/";|"'$MiningCoreAPI'";|g'                                                                    /root/Miningcore.WebUI/js/miningcore.js
               sed -i -e 's|var stratumAddress = window.location.hostname;|var stratumAddress            = "'$MiningCoreStratum':";|g' /root/Miningcore.WebUI/js/miningcore.js

            ## Mover archivos de MiningCore a su ubicación final
               rm -rf /var/www/html/
               mv /root/Miningcore.WebUI/ /var/www/
               mv /var/www/Miningcore.WebUI/ /var/www/html/

            ## Reparar permisos
               chown www-data:www-data /var/www/html/ -Rv
               echo ""

          ;;

        esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Pools Cripto para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
