#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de minería de criptomonedas en Debian10
#------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioDaemon="pooladmin"
DominioPool="localhost"
VersPHP="7.3"

echo ""
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación de una pool de minería de criptomonedas...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "dialog no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install dialog
   fi

menu=(dialog --timeout 10 --checklist "Marca lo que quieras instalar:" 22 76 16)
  opciones=(1 "Instalar la pool rvn-kawpow-pool (Para Ravencoin)" on
            2 "Instalar la pool php-mpos" off
            3 "Instalar NodeJS" off
            4 "Instalar node-multi-hashing" off
            5 "Reparar permisos" off
            6 "Reniciar el sistema" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${ColorVerde}-----------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la pool rvn-kawpow-pool...${FinColor}"
          echo -e "${ColorVerde}-----------------------------------------${FinColor}"
          echo ""

          ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "git no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install git
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
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando la pool MPOS...${FinColor}"
          echo -e "${ColorVerde}------------------------------${FinColor}"
          echo ""

          ## Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tasksel 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tasksel no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tasksel
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
               echo "git no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install git
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

                echo ""
                echo "  Importando la estructura de la base de datos..."
                echo ""
                mysql -p mpos < /var/www/MPOS/sql/000_base_structure.sql

          ## Reparación de permisos
             chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R

        ;;

        3)

          echo ""
          echo -e "${ColorVerde}------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando NodeJS...${FinColor}"
          echo -e "${ColorVerde}------------------------${FinColor}"
          echo ""

          apt-get -y update
          apt-get -y install nodejs npm

        ;;

        4)

          echo ""
          echo -e "${ColorVerde}------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando node-multi-hashing...${FinColor}"
          echo -e "${ColorVerde}------------------------------------${FinColor}"
          echo ""

          npm install multi-hashing

        ;;

        5)

          echo ""
          echo -e "${ColorVerde}-------------------------------------${FinColor}"
          echo -e "${ColorVerde}  Instalando kawpow-stratum-pool...${FinColor}"
          echo -e "${ColorVerde}-------------------------------------${FinColor}"
          echo ""

          cd /root/
          git clone https://github.com/RavenCommunity/kawpow-stratum-pool

        ;;
        5)

          echo ""
          echo -e "${ColorVerde}-------------------------${FinColor}"
          echo -e "${ColorVerde}  Reparando permisos...${FinColor}"
          echo -e "${ColorVerde}-------------------------${FinColor}"
          echo ""

          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/
          find /home/$UsuarioDaemon/$CarpetaSoftLTC/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftARG/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftXMR/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/ -type f -iname "*.sh" -exec chmod +x {} \;
          
          chown root:root /home/$UsuarioDaemon/$CarpetaSoftXCH/bin/chrome-sandbox
          chmod 4755 /home/$UsuarioDaemon/$CarpetaSoftXCH/bin/chrome-sandbox

        ;;

        6)

          echo ""
          echo -e "${ColorVerde}-----------------------------${FinColor}"
          echo -e "${ColorVerde}  Reiniciando el sistema...${FinColor}"
          echo -e "${ColorVerde}-----------------------------${FinColor}"
          echo ""

          shutdown -r now

        ;;

      esac

done

echo ""
echo -e "${ColorVerde}---------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Script de instalación de una pool de minería de criptomonedas, finalizaado.${FinColor}"
echo -e "${ColorVerde}---------------------------------------------------------------------------${FinColor}"
echo ""

