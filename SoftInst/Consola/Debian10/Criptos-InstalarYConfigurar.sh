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
CarpetaSoftLTC="CoreLTC"
CarpetaSoftRVN="CoreRVN"
CarpetaSoftARG="CoreARG"
CarpetaSoftXMR="CoreXMR"
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

menu=(dialog --timeout 5 --checklist "Marca lo que quieras instalar:" 22 76 16)
  opciones=(1 "Crear usuario sin privilegios para ejecutar la pool (obligatorio)" on
            2 "Borrar todas las carteras y configuraciones ya existentes" off
            3 "Instalar cartera de Litecoin" on
            4 "Instalar cartera de Ravencoin" on
            5 "Instalar cartera de Argentum" off
            6 "Instalar cartera de Monero" off
            7 "Instalar cartera de Chia" off
            8 "Instalar la pool MPOS" off
            9 "Crear contraseña para el usuario $UsuarioDaemon" on
           10 "Crear comandos para administrar la pool" on
           11 "Activar auto-ejecución de carteras" off
           12 "Reparar permisos" on
           13 "Reniciar el sistema" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${ColorVerde}  Creando el usuario para ejecutar y administrar la pool...${FinColor}"
          echo ""
          useradd -d /home/$UsuarioDaemon/ -s /bin/bash $UsuarioDaemon
        ;;

        2)
          echo ""
          echo -e "${ColorVerde}  Borrando carteras y configuraciones anteriores...${FinColor}"
          echo ""
          rm -rf /home/$UsuarioDaemon/.litecoin/
          rm -rf /home/$UsuarioDaemon/.raven/
          rm -rf /home/$UsuarioDaemon/.argentum/
          rm -rf /var/www/MPOS/
        ;;

        3)
          echo ""
          echo -e "${ColorVerde}  Instalando el nodo litecoin...${FinColor}"
          echo ""

          echo "Determinando la última versión de litecoin core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "curl no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install curl
            fi
          UltVersLite=$(curl --silent https://litecoin.org | grep linux-gnu | grep x86_64 | grep -v in64 | cut -d '"' -f 2 | sed 2d | cut -d '-' -f 3)
          echo ""
          echo "La última versión de raven es la $UltVersLite"
          
          echo ""
          echo "Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Litecoin/ 2> /dev/null
          rm -rf /root/SoftInst/Litecoin/*
          cd /root/SoftInst/Litecoin/
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "wget no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install wget
            fi
          echo "Pidiendo el archivo en formato tar.gz..."
          echo ""
          wget https://download.litecoin.org/litecoin-$UltVersLite/linux/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          
          echo ""
          echo "Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "tar no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update
              apt-get -y install tar
            fi
          tar -xf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Litecoin/litecoin-$UltVersLite-x86_64-linux-gnu.tar.gz
          
          echo ""
          echo "Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          mkdir -p /home/$UsuarioDaemon/.litecoin/
          touch /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "rpcuser=user1"      > /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "rpcpassword=pass1" >> /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "prune=550"         >> /home/$UsuarioDaemon/.litecoin/raven.conf
          echo "daemon=1"          >> /home/$UsuarioDaemon/.litecoin/raven.conf
          rm -rf /home/$UsuarioDaemon/$CarpetaSoftLTC/
          mv /root/SoftInst/Litecoin/litecoin-$UltVersLite/ /home/$UsuarioDaemon/$CarpetaSoftLTC/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftLTC/bin -type f -exec chmod +x {} \;
          ## Denegar el acceso a la carpeta a los otros usuarios del sistema
             #find /home/$UsuarioDaemon -type d -exec chmod 750 {} \;
             #find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          echo ""
          echo "Arrancando litecoind..."
          echo ""
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoind -daemon"
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getnewaddress" > /home/$UsuarioDaemon/pooladdress-ltc.txt
          echo ""
          echo "La dirección para recibir litecoins es:"
          echo ""
          cat /home/$UsuarioDaemon/pooladdress-ltc.txt
          DirCart=$(cat /home/$UsuarioDaemon/pooladdress-ltc.txt)
          echo ""
          #echo "Información de la cartera:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getwalletinfo"
          #echo ""
          #echo "Direcciones de recepción disponibles:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getaddressesbylabel ''"
          #echo ""
        ;;

        4)
          echo ""
          echo -e "${ColorVerde}  Instalando la cartera de ravencoin...${FinColor}"
          echo ""

          echo "Determinando la última versión de ravencoin core..."
          echo ""
          ## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "curl no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install curl
             fi
          UltVersRaven=$(curl --silent https://github.com/RavenProject/Ravencoin/releases/latest | cut -d '/' -f 8 | cut -d '"' -f 1 | cut -c2-)
          echo ""
          echo "La última versión de raven es la $UltVersRaven"
          echo ""

          echo ""
          echo "Intentando descargar el archivo comprimido de la última versión..."
          echo ""
          mkdir -p /root/SoftInst/Ravencoin/ 2> /dev/null
          rm -rf /root/SoftInst/Ravencoin/*
          cd /root/SoftInst/Ravencoin/
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
             fi
          echo ""
          echo "  Pidiendo el archivo en formato zip..."
          echo ""
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.zip
          echo ""
          echo "  Pidiendo el archivo en formato tar.gz..."
          echo ""
          wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "zip no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install zip
             fi
          unzip /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          mv /root/SoftInst/Ravencoin/linux/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz /root/SoftInst/Ravencoin/
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
          rm -rf /root/SoftInst/Ravencoin/linux/
          rm -rf /root/SoftInst/Ravencoin/__MACOSX/
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar -xf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz
          rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

          echo ""
          echo "Creando carpetas y archivos necesarios para ese usuario..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
          mkdir -p /home/$UsuarioDaemon/.raven/
          touch /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcuser=user1"      > /home/$UsuarioDaemon/.raven/raven.conf
          echo "rpcpassword=pass1" >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "prune=550"         >> /home/$UsuarioDaemon/.raven/raven.conf
          echo "daemon=1"          >> /home/$UsuarioDaemon/.raven/raven.conf
          rm -rf /home/$UsuarioDaemon/$CarpetaSoftRVN/
          mv /root/SoftInst/Ravencoin/raven-$UltVersRaven/ /home/$UsuarioDaemon/$CarpetaSoftRVN/
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
          find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftRVN/bin -type f -exec chmod +x {} \;
          ## Denegar el acceso a la carpeta a los otros usuarios del sistema
             #find /home/$UsuarioDaemon -type d -exec chmod 750 {} \;
             #find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;

          echo ""
          echo "Arrancando ravencoind..."
          echo ""
          su $UsuarioDaemon -c /home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend
          sleep 5
          su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getnewaddress" > /home/$UsuarioDaemon/pooladdress-rvn.txt
          echo ""
          echo "La dirección para recibir ravencoins es:"
          echo ""
          cat /home/$UsuarioDaemon/pooladdress-rvn.txt
          DirCart=$(cat /home/$UsuarioDaemon/pooladdress-rvn.txt)
          echo ""
          #echo "Información de la cartera:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getwalletinfo"
          #echo ""
          #echo "Direcciones de recepción disponibles:"
          #echo ""
          #su $UsuarioDaemon -c "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getaddressesbyaccount ''"
          #echo ""
        ;;

        5)
          echo ""
          echo -e "${ColorVerde}  Instalando la cartera de argentum...${FinColor}"
          echo ""
        ;;

        6)
          echo ""
          echo -e "${ColorVerde}  Instalando la cartera de monero...${FinColor}"
          echo ""
          
          echo ""
          echo "Descargando el archivo comprimido de la última release..."
          echo ""
          ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "wget no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install wget
             fi
          mkdir -p /root/SoftInst/Monerocoin/ 2> /dev/null
          rm -rf /root/SoftInst/Monerocoin/*
          wget https://downloads.getmonero.org/gui/linux64 -O /root/SoftInst/Monerocoin/monero.tar.bz2

          echo ""
          echo "Descomprimiendo el archivo..."
          echo ""
          ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
             if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
               echo ""
               echo "tar no está instalado. Iniciando su instalación..."
               echo ""
               apt-get -y update
               apt-get -y install tar
             fi
          tar xjfv /root/SoftInst/Monerocoin/monero.tar.bz2 -C /root/SoftInst/Monerocoin/
          rm -rf /root/SoftInst/Monerocoin/monero.tar.bz2

          echo ""
          echo "Preparando la carpeta final..."
          echo ""
          mkdir -p /home/$UsuarioDaemon/$CarpetaSoftXMR/bin/ 2> /dev/null
          find /root/SoftInst/Monerocoin/ -type d -name monero* -exec cp -r {}/. /home/$UsuarioDaemon/$CarpetaSoftXMR/bin/ \;
          rm -rf /root/SoftInst/Monerocoin/*
          mkdir -p /home/$UsuarioDaemon/.config/monero-project/ 2> /dev/null
          echo "[General]"                                       > /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "account_name=$UsuarioDaemon"                    >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "askPasswordBeforeSending=true"                  >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "autosave=true"                                  >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "autosaveMinutes=10"                             >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "blackTheme=true"                                >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "blockchainDataDir=/home/$UsuarioDaemon/.monero" >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "checkForUpdates=true"                           >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "customDecorations=true"                         >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "fiatPriceEnabled=true"                          >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "fiatPriceProvider=kraken"                       >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "language=Espa\xf1ol"                            >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "language_wallet=Espa\xf1ol"                     >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "locale=es_ES"                                   >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "lockOnUserInActivity=true"                      >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "lockOnUserInActivityInterval=1"                 >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "transferShowAdvanced=true"                      >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "useRemoteNode=false"                            >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf
          echo "walletMode=2"                                   >> /home/$UsuarioDaemon/.config/monero-project/monero-core.conf

          echo ""
          echo "Instalando paquetes necesarios para ejecutar la cartera..."
          echo ""
          apt-get -y install libxcb-icccm4
          apt-get -y install libxcb-image0
          apt-get -y install libxcb-keysyms1
          apt-get -y install libxcb-randr0
          apt-get -y install libxcb-render-util0
          apt-get -y install libxcb-xkb1
          apt-get -y install libxkbcommon-x11-0
        ;;

        7)
          echo ""
          echo -e "${ColorVerde}  Instalando la cartera de chia...${FinColor}"
          echo ""
        ;;

        8)
          echo ""
          echo -e "${ColorVerde}  Instalando la pool MPOS...${FinColor}"
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
                echo "Importando la estructura de la base de datos..."
                echo ""
                mysql -p mpos < /var/www/MPOS/sql/000_base_structure.sql
        ;;

         9)
          echo ""
          echo -e "${ColorVerde}  Cambiando la contraseña del usuario $UsuarioDaemon...${FinColor}"
          echo ""
          paswd $UsuarioDaemon
        ;;

        10)
          echo ""
          echo -e "${ColorVerde}  Creando comandos para administrar la pool...${FinColor}"
          echo ""

          ## Comandos para litecoin

          chmod +x /home/$UsuarioDaemon/$CarpetaSoftLTC/bin/*

          echo '#!/bin/bash'                                                          > /home/$UsuarioDaemon/litecoin-info-cartera.sh
          echo ""                                                                    >> /home/$UsuarioDaemon/litecoin-info-cartera.sh
          echo "/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoin-cli getwalletinfo" >> /home/$UsuarioDaemon/litecoin-info-cartera.sh
          chmod +x                                                                      /home/$UsuarioDaemon/litecoin-info-cartera.sh

          ## Comandos para ravencoin

          chmod +x /home/$UsuarioDaemon/$CarpetaSoftRVN/bin/*

          echo '#!/bin/bash'                                                       > /home/$UsuarioDaemon/ravencoin-info-cartera.sh
          echo ""                                                                 >> /home/$UsuarioDaemon/ravencoin-info-cartera.sh
          echo "/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-cli getwalletinfo" >> /home/$UsuarioDaemon/ravencoin-info-cartera.sh
          chmod +x                                                                   /home/$UsuarioDaemon/ravencoin-info-cartera.sh

        ;;

        11)
          echo ""
          echo -e "${ColorVerde}  Activando auto-ejecución de carteras...${FinColor}"
          echo ""

          ## Autoejecución de Litecoin
             echo ""
             echo "Agregar litecoind a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoind"
             echo "su "$UsuarioDaemon" -c '/home/"$UsuarioDaemon"/"$CarpetaSoftLTC"/bin/litecoind -daemon'" >> /root/scripts/ComandosPostArranque.sh

             #echo ""
             #echo "Creando el servicio para systemd..."
             #echo ""
             #echo "[Unit]"                                                                > /etc/systemd/system/litecoind.service
             #echo "Description=Litecoin daemon"                                          >> /etc/systemd/system/litecoind.service
             #echo "After=network.target"                                                 >> /etc/systemd/system/litecoind.service
             #echo ""                                                                     >> /etc/systemd/system/litecoind.service
             #echo "[Service]"                                                            >> /etc/systemd/system/litecoind.service
             #echo "User=$UsuarioDaemon"                                                  >> /etc/systemd/system/litecoind.service
             #echo "Group=$UsuarioDaemon"                                                 >> /etc/systemd/system/litecoind.service
             #echo ""                                                                     >> /etc/systemd/system/litecoind.service
             #echo "Type=forking"                                                         >> /etc/systemd/system/litecoind.service
             #echo "PIDFile=/home/$UsuarioDaemon/litecoind-pid.txt"                       >> /etc/systemd/system/litecoind.service
             #echo "ExecStart=/home/$UsuarioDaemon/$CarpetaSoftLTC/bin/litecoind -daemon" >> /etc/systemd/system/litecoind.service
             #echo "Restart=always"                                                       >> /etc/systemd/system/litecoind.service
             #echo "PrivateTmp=true"                                                      >> /etc/systemd/system/litecoind.service
             #echo "TimeoutStopSec=60s"                                                   >> /etc/systemd/system/litecoind.service
             #echo "TimeoutStartSec=2s"                                                   >> /etc/systemd/system/litecoind.service
             #echo "StartLimitInterval=120s"                                              >> /etc/systemd/system/litecoind.service
             #echo "StartLimitBurst=5"                                                    >> /etc/systemd/system/litecoind.service
             #echo "[Install]"                                                            >> /etc/systemd/system/litecoind.service
             #echo "WantedBy=multi-user.target"                                           >> /etc/systemd/system/litecoind.service
             #touch /home/$UsuarioDaemon/litecoind-pid.txt
             #chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/litecoind-pid.txt
             #systemctl enable litecoind.service

          ## Autoejecución de Ravencoin
             echo ""
             echo "Agregar ravend a los ComandosPostArranque..."
             echo ""
             echo "chmod +x /home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend"
             echo "su $UsuarioDaemon -c '/home/"$UsuarioDaemon"/"$CarpetaSoftRVN"/bin/ravend'" >> /root/scripts/ComandosPostArranque.sh

             echo ""
             echo "Creando el archivo de autoejecución de raven-qt para escritorio..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                                     > /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Type=Application"                                                                   >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Name=Raven"                                                                         >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Exec=/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/raven-qt -min -testnet=0 -regtest=0"  >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Terminal=false"                                                                     >> /home/$UsuarioDaemon/.config/autostart/raven.desktop
             echo "Hidden=false"                                                                       >> /home/$UsuarioDaemon/.config/autostart/raven.desktop

             #echo ""
             #echo "Creando el servicio para systemd..."
             #echo ""
             #echo "[Unit]"                                                             > /etc/systemd/system/ravend.service
             #echo "Description=Ravencoin daemon"                                      >> /etc/systemd/system/ravend.service
             #echo "After=network.target"                                              >> /etc/systemd/system/ravend.service
             #echo ""                                                                  >> /etc/systemd/system/ravend.service
             #echo "[Service]"                                                         >> /etc/systemd/system/ravend.service
             #echo "User=$UsuarioDaemon"                                               >> /etc/systemd/system/ravend.service
             #echo "Group=$UsuarioDaemon"                                              >> /etc/systemd/system/ravend.service
             #echo ""                                                                  >> /etc/systemd/system/ravend.service
             #echo "Type=forking"                                                      >> /etc/systemd/system/ravend.service
             #echo "PIDFile=/home/$UsuarioDaemon/ravend-pid.txt"                       >> /etc/systemd/system/ravend.service
             #echo "ExecStart=/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend -daemon -pid=/home/$UsuarioDaemon/ravend.pid.txt -conf=/home/$UsuarioDaemon/.raven/raven.conf -datadir=/var/lib/ravend -disablewallet"
             #echo "ExecStart=/home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ravend -daemon" >> /etc/systemd/system/ravend.service
             #echo "Restart=always"                                                    >> /etc/systemd/system/ravend.service
             #echo "PrivateTmp=true"                                                   >> /etc/systemd/system/ravend.service
             #echo "TimeoutStopSec=60s"                                                >> /etc/systemd/system/ravend.service
             #echo "TimeoutStartSec=2s"                                                >> /etc/systemd/system/ravend.service
             #echo "StartLimitInterval=120s"                                           >> /etc/systemd/system/ravend.service
             #echo "StartLimitBurst=5"                                                 >> /etc/systemd/system/ravend.service
             #echo "[Install]"                                                         >> /etc/systemd/system/ravend.service
             #echo "WantedBy=multi-user.target"                                        >> /etc/systemd/system/ravend.service
             #touch /home/$UsuarioDaemon/ravend-pid.txt
             #chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ravend-pid.txt
             #systemctl enable ravend.service

          ## Autoejecución de monero
             echo ""
             echo "Creando el archivo de autoejecución..."
             echo ""
             mkdir -p /home/$UsuarioDaemon/.config/autostart/ 2> /dev/null
             echo "[Desktop Entry]"                                                 > /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Type=Application"                                               >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Name=Monero"                                                    >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Exec=/home/$UsuarioDaemon/Monerocoin/bin/monero-wallet-gui %u"  >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Terminal=false"                                                 >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
             echo "Hidden=false"                                                   >> /home/$UsuarioDaemon/.config/autostart/monero.desktop
        ;;

        12)
          echo ""
          echo -e "${ColorVerde}  Reparando permisos...${FinColor}"
          echo ""
          chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/
          find /home/$UsuarioDaemon/ -type d -exec chmod 775 {} \;
          find /home/$UsuarioDaemon/ -type f -exec chmod 664 {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftLTC/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftRVN/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftARG/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/$CarpetaSoftXMR/bin/ -type f -exec chmod +x {} \;
          find /home/$UsuarioDaemon/ -type f -iname "*.sh" -exec chmod +x {} \;
        ;;

        13)
          echo ""
          echo -e "${ColorVerde}  Reiniciando el sistema...${FinColor}"
          echo ""
          shutdown -r now
        ;;

      esac

done

echo ""
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Script de instalación de una pool de minería de criptomonedas, finalzaado.${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------------------------${FinColor}"
echo ""

echo "RAVEN:"
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 8767."
echo "Si has instalado RavenCore en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 8767"
echo ""

echo "MONERO:"
echo "Recuerda editar el cortafuegos del ordenador para que acepte conexiones TCP en el puerto 18080."
echo "Si has instalado Monero en una MV de Proxmox agrega una regla a su cortauegos indicando:"
echo ""
echo "Dirección: out"
echo "Acción: ACCEPT"
echo "Protocolo: tcp"
echo "Puerto destino: 18080"
echo ""

